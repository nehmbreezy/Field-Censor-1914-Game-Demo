package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.system.ui.FlxSystemButton;
import flixel.text.FlxText;
import flixel.ui.FlxTypedButton;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;
import Std;
import openfl.Assets;
import haxe.ds.ArraySort;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class PlayState extends FlxState	
{	
	private var cursors : Cursors;
	
	private var inited : Bool;
	
	//the letter data and time data
	public var letterData : LetterData;
	private var letterCount : Int;
	private var dayCount : Int;
	private var logTimer : FlxTimer;
	private var citationTimer : FlxTimer;
	private var progressTimer : FlxTimer;
	
	private var logFont : Dynamic;
	private var logFontSize : Int;
	private var stackFont : Dynamic;
	private var stackFontSize : Int;
	
	//the prestige score count
	private var prestigeIcon : FlxSprite; //not actually used rn
	
	//skip for the progress function
	private var skip: Bool;
	private var posSwitch : Bool;
	private var restartLine : Bool;
	
	//setting up the rulebook
	private var rulebook : Rulebook;
	
	//testing the outbox tray.
	private var outboxSymbol : Outbox;
	
	private var crudeTimer : FlxTimer; //so the progress outbox doesn't trigger right after you click it
	private var crudePause : Bool;
	
	//letter start points and the letters
	public var currentReadOnlyLetter : ReadOnlyLetter;
	public var citation : ReadOnlyLetter;
	public var currentCensorLetter : CensorLetter;
	
	private var letterStartX : Int;
	private var letterStartY: Int;
	private var letterFinishX : Int;
	private var letterFinishY: Int;
	
	private var portraitStartX: Int;
	private var portraitStartY: Int;
	
	private function init():Void 
	{
		if (inited)
		{
			cursors.destroy();
			Registry.prestigeCounter.destroy();
			Registry.log.destroy();
			Registry.stackBox.destroy();
			Registry.toolbar.destroy();
			outboxSymbol.destroy();
			rulebook.destroy();
		}
		
		var prestigeCounterX : Int = 1670;
		var prestigeCounterY : Int = 0;
		var outBoxX : Int = 1510;
		var outBoxY : Int = 800;
		var stackBoxX : Int = 210;
		var stackBoxY : Int = 3;
			
		//setting up the rulebook
		rulebook = new Rulebook('assets/cards/notebook.png', 'assets/cards/notebook.png');
		rulebook.initDailyRules(letterData.rules, letterData.dayRules[dayCount]);
		rulebook.setVisible(false);
		add(rulebook);
		
		outboxSymbol = new Outbox(1600, 800, 'assets/icons/outbox1.png');
		add(outboxSymbol);
		outboxSymbol.shrink();

		Registry.toolbar = new Toolbar();
		add(Registry.toolbar);
		Registry.toolbar.populate(letterData.daysTools[dayCount]);
		
		Registry.prestigeCounter = new FlxText(prestigeCounterX, prestigeCounterY, 0, Std.string(Registry.prestigeScore));
		Registry.prestigeCounter.setFormat('assets/fonts/typewriter2.ttf', 150, FlxColor.MAROON);
		add(Registry.prestigeCounter);
		
		Registry.log = new FlxText(800, 100, 0, '', 20);
		Registry.log.setFormat(logFont, logFontSize, FlxColor.WHITE);
		add(Registry.log);
		
		Registry.stackBox = new FlxText(stackBoxX, stackBoxY, 1000, "");
		add(Registry.stackBox);
		Registry.stackBox.setFormat(stackFont, stackFontSize, FlxColor.WHITE);
		
		cursors = new Cursors();
		add(cursors);
		
		inited = true;
	}
	
	override public function create():Void 
	{
		super.create();
		
		
		
		inited = false;
		crudePause = false;
		
		//this is used for the progress() function, to avoid skipping the 0th letter
		skip = false;
		
		//these vars are for drawing the line, 
		posSwitch = false; //so that the coords swap every frame
		restartLine = true;	//so that when you release the mouse the line doens't continue	
		Registry.drawing = false; //to record when the line should be drawing
		Registry.prevMousePos = [0, 0];
		Registry.currentMousePos = [0, 0];
		
		//set log font and size here
		logFont = 'assets/fonts/handwriting1.ttf';
		logFontSize = 150;
		stackFont = 'assets/fonts/handwriting1.ttf';
		stackFontSize = 55;
		
		// We need the MouseEventManager plugin for sprite-mouse-interaction
		FlxG.plugins.add(new MouseEventManager());

		// A table as a background
		add(new FlxSprite(0, 0, "assets/wooden_desk.png"));

		//declaring the letter data variable, where all the letters are stored
		//starting of with one letter
		
		//starting and ending positions for the entrance tweens
		letterStartX = -400;
		letterStartY = 20;
		letterFinishX = 280;
		letterFinishY = 50;
		
		//setting up the main letters for this state
		Registry.addNewLetter = false;
		letterData = new LetterData();
		currentReadOnlyLetter = new ReadOnlyLetter(letterStartX, letterStartY, letterData.day1[0].text, 'assets/cards/paper_portrait2.png', 'assets/cards/paper_portrait2temp.png');
		add(currentReadOnlyLetter);
		FlxTween.tween(currentReadOnlyLetter.card, { x:letterFinishX, y:letterFinishY }, 0.9, { ease: FlxEase.quadOut});
		
		currentCensorLetter = new CensorLetter( 0, 0, ' ' , 'assets/cards/postcardA1.png', 'assets/cards/postcardA1temp.png', false, false, false);
		
		Registry.showRulebook = false;
		letterCount = 0;
		dayCount = 0;
		
		Registry.toolSelected = move;
		FlxG.mouse.visible = false;
		Registry.feedback = ' ';
	
		//prestigeCounter
		//which contains important global variables
		//the prestige increment from one successfully letter
		Registry.prestigeIncrement = 1;
		Registry.prestigeDecrement = -1;	
		Registry.prestigeScore = 0;
		
		
		
		init(); 
		
		citation = new ReadOnlyLetter(/* doesn't matter just to keep offscreen*/-1000, -600, '.', 'assets/cards/citation.png', 'assets/cards/citationTemp.png');
		add(citation);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
		
		//cycling through the letters
		if (FlxG.keys.justPressed.ENTER) //in the future this will be like 'if (progress == true)' after the outbox is activated
		{
			progress();
		}
		
		if (Registry.showRulebook == false && rulebook.isVisible)
		{
			rulebook.setVisible(false);
		}
		else if (Registry.showRulebook == true && rulebook.isVisible == false)
		{
			rulebook.setVisible(true);
		}
		
		Registry.drawing = false;
		if (Registry.toolSelected == pencil)
		{
			//drawing the line!
			if (FlxG.mouse.pressed)
			{
				/*
				 * Every frame : When drawing = true, draw a line between the mouse's previous position and its current position.
				 * */
				if (restartLine == true) 
				{
					Registry.currentMousePos = [Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y)];
					Registry.prevMousePos = Registry.currentMousePos;
					restartLine = false;
				}
				
				else if (posSwitch == false)
				{
					Registry.prevMousePos = [Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y)];
					posSwitch = true;
				}
				else 
				{
					Registry.currentMousePos = [Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y)];
					posSwitch = false;
				}
				
				Registry.drawing = true;
				
			}
			else 
			{
				Registry.drawing = false;
			}
			if (FlxG.mouse.justReleased)
			{
				restartLine = true;
			}
			
		}
		
		if (aLetterIsOverTheOutbox())
		{
			//so that the mouse cursor disappears
			cursors.hideCursor();
			outboxSymbol.grow();
			
			if (FlxG.mouse.justReleased && crudePause == false)
			{
				crudePause = true;
				crudeTimer = new FlxTimer(3,crudeDelay);
				
				currentCensorLetter.card.dragging = false;
				progress();
			}
		}
	
		// Keyboard hotkey to reset the state
		if (FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}
		
		
		if (Registry.addNewLetter)
		{
			addTheNextLetter();
		}

	}
		
	private function crudeDelay(timer:FlxTimer):Void
	{
		crudePause = false;
	}
	
	private function updatePrestige (change:Int) : Void {
		//updating prestige score
		Registry.prestigeScore = Registry.prestigeScore + change;
		Registry.prestigeCounter.text = Std.string(Registry.prestigeScore);
	}
	
	private function aLetterIsOverTheOutbox():Bool {
		if (outboxSymbol.mouseOver && Registry.toolSelected == move && (currentReadOnlyLetter.card.dragging||currentCensorLetter.card.dragging))
		{
			return true;
		}
		
		else {
			return false;
		}
	}
	
	private function removePreviousLetter(prevLetter:LetterInfo):Void
	{
		
	}
	
	public function progress():Void 
	{
		var letter = letterData.days[dayCount][letterCount];
		
		//part 1 v2
		if (letter.type == censorable && skip == false)
		{
			currentCensorLetter.exit(); //this is causing issues rn
			//do stuff with the citation here btw
			citationEnter();
		}
		else if (letter.type == readOnly && skip == false) 
		{
			currentReadOnlyLetter.exit();
		}
		
	}
	
	private function addTheNextLetter() {
				//part 2 -- putting the next letter on screen
		if (letterCount == 0 && skip == true) // a new day 
		{
			addLetter(letterData.days[dayCount][letterCount]);
			
			init();
			citation.keepOffscreen();
			Registry.log.alpha = 1;
			Registry.log.text = 'Day ${dayCount+1}';
			
			//add the next letter somehow
			
			logTimer = new FlxTimer (4, clearLog);
			skip = false;
		}
		
		else if(letterCount + 1 < letterData.days[dayCount].length) // to check if the last letter is reached -- the end of a day
		{
			letterCount++; // triggers the next letter in the array
			addLetter(letterData.days[dayCount][letterCount]); //adds THIS letter in the day array
			
			init(); //re-inits a bunch of graphics so they go to the top layer (crude)
		}
		
		else //if this activates, the day is over
		{ 
			//could change state here for MENUSTATE Or whatever...
		
			
			
			//show end of day
			//activate the shop or feedback screen here later on!
			Registry.log.alpha = 1;
			Registry.log.text = 'End of Day ${dayCount+1}...';
			logTimer = new FlxTimer (6, clearLog);
			progressTimer = new FlxTimer (7, progressTimerComplete);
			Registry.addNewLetter = false;
			
			//reset daily variables
			letterCount = 0; //resets to 0
			dayCount++; //progresses + 1
			skip = true;
			
			Registry.toolbar.populate(letterData.daysTools[dayCount]); //here add the next day's tool set
			//rulebook text should change here
			rulebook.initDailyRules(letterData.rules, letterData.dayRules[dayCount]);
			
			//if this activates, the game is over
			if (dayCount >= letterData.days.length)
			{
				//end the game here!
				FlxG.switchState(new FinishState());
			}
		}
		
		Registry.addNewLetter = false;
	}
	
	private function addLetter(letter:LetterInfo) :Void{
		//if (dayCount == 6 && letterCount == 3) 
		//{
			////story variable or something
			////story decision = 3;
		//}
		
		
		if (letter.type == readOnly)
		{
			currentReadOnlyLetter = new ReadOnlyLetter (letterStartX, letterStartY, letter.text, 'assets/cards/paper_portrait2.png', 'assets/cards/paper_portrait2temp.png');
			add(currentReadOnlyLetter);
			
			FlxTween.tween(currentReadOnlyLetter.card, { x:letterFinishX, y:letterFinishY }, 0.5, { ease: FlxEase.quadOut});
		}
		
		else if (letter.type == censorable)
		{
			currentCensorLetter = new CensorLetter(letterStartX,letterStartY,letter.text,'assets/cards/postcardA1.png','assets/cards/postcardA1temp.png',letter.needsApproval,letter.needsMissing,letter.needsKilled);
			add(currentCensorLetter);
			
			FlxTween.tween(currentCensorLetter.card, { x:letterFinishX, y:letterFinishY }, 0.5, { ease: FlxEase.quadOut});
		}
		
		
	}
	
	private function citationEnter() 
	{	
		var citationX : Int = 660;
		var citationY : Int = 960;
		
		citation.resetText(citationX, citationY , Registry.feedback);
	}

	
	private function progressTimerComplete(timer:FlxTimer):Void
	{
		//do something with the citation here
		Registry.addNewLetter = true;
	}
	
	private function clearLog (timer:FlxTimer):Void {
		Registry.log.alpha = 0;
	}
}	