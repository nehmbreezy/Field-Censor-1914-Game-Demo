package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxTimer;
import flixel.util.FlxSort;

/**
 * This is a letter class that will contain all the letter's text and censor data (if it's censorable).
 * @author Alexander
 */
class Letter extends FlxGroup //Which is just FlxTypedGroup<FlxBasic>
{
	//what was censored, what was optional and whether it was right
	public var whatCensored : Array <Int>;
	public var optionalCensored : Array <Int>;
	public var compareCensored : Array<Int>;
	public var censoredCorrectly : Bool;
	
	//internal vars for checking what words were missed
	private var whatWasIncorrect : Array<Int>;
	private var whatWasMissed: Array<Int>;
	
	//the canvas
	private var canvas: FlxSprite;
	private var lineStyle1 : LineStyle; 
	
	//whether readOnlyies should auto delete
	public var autoArchive : Bool;
	
	//the background card and the word arrays (important)
	public var card : DraggableFlxSprite;
	private var words : Array <String>;
	private var sortedWords : Array<String>;
	public var buttons : Array<TextButton>;
	
	//private variables for setting the margins and font
	private var postcardFont : Dynamic;
	private var fontSize : Int;
	private var fontSizePostcard: Int;
	private var typewriterFont : Dynamic;
	private var left : Float;
	private var top : Float;
	private var reset : Bool;
	private var wordSpacing : Float;
	private var lineSpacing : Float;
	private var emptyLineSpacing :Float;
	private var rightMargin : Float;
	private var topMargin : Float;
	private var leftMargin : Float;

	//internal reference stuff
	public var type : LetterType; //for internal reference
	private var showLog : FlxTimer; //for showing the log so the feedback is a little delayed
	private var logTimer:FlxTimer; //for hiding the log after feedback
	private var feedbackCounter: Int; //for counting how many words have been censored
	
	//for whether the letter needs approval, killed, and missing
	public var needsApproval : Bool;
	public var needsKilled : Bool;
	public var needsMissing : Bool;
	public var killedStamped : Bool;
	public var missingStamped : Bool;
	public var approvalStamped : Bool;
	public var kStamped : Bool;
	public var mStamped : Bool;
	
	//stamps
	private var aStamp : FlxSprite; //the stamp sprite
	private var kStamp : FlxSprite;
	private var mStamp : FlxSprite;
	
	//clean template for clearing the cards
	private var template : FlxSprite;
	
	//for the ReadOnly stuff
	public var readText : FlxText;
	
	public function new(startX, startY, text:String, cardGraphic:Dynamic, letterType:LetterType) 
	{	
			
		if (letterType == censorable)
		{
			super(360); //why the wordcoutn can't exceed 300
		}
		else {
			super(5); //calling super with 'maxsize' -- max number of objects in the group
		}
		
		card = new DraggableFlxSprite(startX, startY, cardGraphic);
		add(card);
	
		//initiating the local variables 
		words = [''];
		sortedWords = [''];
		buttons = [Registry.testButton];
		
		//determing FONT SIZE AND FONT STYLE
		postcardFont = "assets/fonts/handwriting1.ttf";
		typewriterFont = "assets/fonts/typewriter2.ttf"; 
		fontSize = 23; //for instructs
		fontSizePostcard = 36;
		
		//line spacing for the text
		wordSpacing = 4;
		lineSpacing = 3;
		emptyLineSpacing = 10;
		
		//starting margins
		rightMargin = card.width - 100;
		topMargin = top = 30;
		leftMargin = left = 25;
			
		//switch handwritings by having the new function declare a name (enum), e.g Greg, Felix, etc. then makea  switch(case) thing inside censorable that has presets for the handwriting, line spacings, font size.

		switch(letterType) {
			case censorable: 
				{
					lineStyle1 = { color : FlxColor.CHARCOAL, thickness : 27.5, pixelHinting : false};
					
					//canvas = new FlxSprite();
					//canvas.makeGraphic(Std.int(card.width), Std.int(card.height), FlxColor.TRANSPARENT, true);
					//add(canvas);
					////
					////initiating internal variables	
					//compareCensored = []; //this is later filled in LetterData
					//whatCensored = [];
					//feedbackCounter = 0;
					//optionalCensored = []; //this is later filled in LetterData
								//
					////declaring type and sorting stuff
					//type = censorable;
					//sortText(text); //sort it
					//populate(); // fill the buttons[] array
				//
					////by default stamp approvals are FALSE
					//needsApproval = false;
					//needsMissing = false;
					//needsKilled = false;
				//
					////adding the words
					//for (i in 0...sortedWords.length)
						//{
							//buttons[i].x = - 90;
							//buttons[i].y = - 90;
							//add(buttons[i]);
						//}
							//
					//
					////creating the stamp and setting approved to false
					//aStamp = new FlxSprite(0, 0, "assets/stamps/approval_stamp.png");
					//approvalStamped = false;
					//
					//kStamp = new FlxSprite(0, 0, "assets/stamps/killed_stamp.png");
					//kStamped = false;
					//
					//mStamp = new FlxSprite(0, 0, "assets/stamps/missing_stamp.png");
					//mStamped = false;
					//
					////creating template to clean stamp marks later
					//template = new FlxSprite(0, 0, "assets/cards/postcardA1temp.png");
					
				}
				
			case readOnly: 
				{
					type = readOnly;
					readText = new FlxText(card.x + left, card.y + top, rightMargin + 40, text, fontSize, true);
				
					add(readText);
					
					readText.setFormat(typewriterFont, fontSize, FlxColor.BLACK);
					readText.antialiasing = false;
		
					card.stamp(readText, Std.int(leftMargin), Std.int(topMargin));
					readText.destroy();
					
					autoArchive = false;
				}
				
			case citation:
				{
					type = citation;
					
					readText = new FlxText(card.x + left, card.y + top, rightMargin, text, fontSize, true);
					add(readText);
					
					readText.setFormat(typewriterFont, fontSize, FlxColor.BLACK);
					readText.antialiasing = false;
					
					autoArchive = false;
				}
		}
	}
	
	//This function iterates through a string, adding each letter to a temporary word which is then added to an array of standalone words
	//when a space is detected. It preserves # as line breaks. 
	private function sortText(inputString):Void
	{
		//temp variables used in sorting
		var iterator = new StringIterator(inputString);
		var char: String;
		var tempWord : String = "";
		var wordCount : Int = 0;
		
		var theseWordsToBeOptional : Bool = false;
		var theseWordsToBeCensored : Bool = false;
		
		/* As we iterate through the string, we need to separate words by spaces, detect linebreaks.
		 * For detecting censorship stuff, we just need to detect which words in the array we're outputting (sortedWords), and record those IDs.
		 * 
		 * 
		 * 
		 * */
		
		for (char in iterator) {
			if (char == '*') 
			{//if it hit's a star symbol, it toggles theseWordsToBeCensored 
				if (theseWordsToBeCensored == false)
				{
					theseWordsToBeCensored = true;
				}
				else
				{
					theseWordsToBeCensored = false;
					compareCensored.push(wordCount); //but, if it's already on, it also adds the last word to the array, so that words like *this* don't get ignored
				}
				continue;
			}
			else if (char == '&')
			{//likewise with theseWordsToBeOptional
				if (theseWordsToBeOptional == false)
				{
					theseWordsToBeOptional = true;
				}
				else 
				{
					theseWordsToBeOptional = false;
					optionalCensored.push(wordCount); //likewise here
				}
				continue;
			}
			
			else if (char == " ") {
				//removing the spaces between words
				
				//if you reach the end of the word and these variables are still true, then add them to the array of optional or mustCensor words
				if (theseWordsToBeCensored)
				{
					compareCensored.push(wordCount);
				}
				
				else if (theseWordsToBeOptional)
				{
					optionalCensored.push(wordCount);
				}
				
				sortedWords[wordCount] = tempWord;
				tempWord = "";
				wordCount++;
				continue;
			}
			else if (char == "#") {
				//this is a line break
				sortedWords[wordCount] = tempWord;
				wordCount++;
				sortedWords[wordCount] = '#';
				wordCount++;
				tempWord = "";
				continue;
			}
			else
			{
				tempWord = tempWord + char;
			}
		}
	}
	
	private function populate():Void
	{
		//populating the array
		for (i in 0...sortedWords.length) 
		{
			buttons[i] = new TextButton(0, 0, 0, sortedWords[i]);
			buttons[i].setFormat(postcardFont, fontSizePostcard, FlxColor.BLACK);
		}	
	}
	
	private function drawCensorLine(offset:Float, style:LineStyle) {
		canvas.drawLine(FlxG.mouse.x - offset - card.x, FlxG.mouse.y - offset - card.y, FlxG.mouse.x + offset - card.x, FlxG.mouse.y + offset - card.y, style);
	}
	
	private function drawingLine (offset:Float, style:LineStyle)
	{
		canvas.drawLine(Registry.prevMousePos[0] - card.x - offset, Registry.prevMousePos[1] - card.y - offset, Registry.currentMousePos[0] - card.x + offset, Registry.currentMousePos[1] - card.y + offset, style);
	}
	
	override public function update():Void
	{
		super.update();
		
		////resetting variables each frame so text doesn't run away
		top = topMargin;
		left = leftMargin;
		reset = false;
		
		if(type == censorable)
		{			
			canvas.x = card.x;
			canvas.y = card.y;
			
			//DRAWING THE BRUSH ON THE CARD
			if (FlxG.mouse.justPressed && Registry.toolSelected == pencil &&card.mouseOver == true) // the first dot
			{
				drawCensorLine(0.1, lineStyle1);
			}
			
			if(Registry.drawing==true)
			{
				
				if (card.mouseOver)
				{
					//drawing the line on the card canvas with drawing = true
					
					drawingLine(0, lineStyle1);
					
					card.stamp(canvas);
					canvas.fill(FlxColor.TRANSPARENT);	
				}
			}
			
			
			
				
			//Displaying the text -- which follows the card graphic, ideally
			for (i in 0...buttons.length) 
			{
				if (buttons[i].stamped == false)
				{
					//buttons[i].alpha = 1;
					//if there is a paragraph break (#), the top margin moves down
					if (buttons[i].text == '#')
					{
						buttons[i].alpha = 0; //hides the #
						top = top + buttons[i].height + emptyLineSpacing;
						left = leftMargin - 36;
						reset = true;
					}
					
					//if the next text button's width + the left margin width exceeds the right Margin, go to the next line
					if (buttons[i].width + left >= rightMargin) {
						top = top + buttons[i].height + lineSpacing;
						left = leftMargin;
						reset = true;
					}
					
					//this next chunk sets the left margin, where text should start, and places the word on the x axis. 
					//The left margin increases to the right as the number of words goes up
					
					if (i == 0 || reset == true) //so it doesn't call an error on the first run
					{
						buttons[i].x = card.x  + left; //setting x coords
						buttons[i].storedX = left;
						reset = false;
					}
					else
					{
						left = left + buttons[i - 1].width + wordSpacing;
						buttons[i].x = card.x + left; //setting x coords
						buttons[i].storedX = left;
					} 
					
					buttons[i].y = card.y + top; //setting the y co-ords
					buttons[i].storedY = top;
					
					////stamp the words to card
					card.stamp(buttons[i], Std.int(left), Std.int(top));
					buttons[i].alpha = 0;
					
					//setting stamped to true
					buttons[i].stamped = true;
				}
				 
				else 
				{
					buttons[i].x = buttons[i].storedX + card.x;
					buttons[i].y = buttons[i].storedY + card.y;
				}
				
				//getting feedback and storing what they censored
				if (buttons[i].clicked == true && buttons[i].alreadyDone != true)
				{
					//Adds currently censored word then disappears
					Registry.log.alpha = 1;
					Registry.log.text = buttons[i].text + ' ' + i;
					
					logTimer = new FlxTimer (1.3, clearLog);
					buttons[i].alreadyDone = true;
						
					if (Registry.stackBox.height > 980)
					{
						clearStackBox();
					}
					
					Registry.stackBox.text = Registry.stackBox.text + '\n' + buttons[i].text; //+ '  ' + i; UNCOMMENT THIS TO SHOW ID NUMBERS
					
					//storing it internally
					whatCensored[feedbackCounter] = i;
					feedbackCounter++;
				}
				
			}
			
			//stamping if stamp tool selected, mouse pressed, and you haven't stamped it already
			if (Registry.toolSelected == stamp && FlxG.mouse.justPressed) //&& approvalStamped == false)
			{
				//checking if there's an overlap
				if (FlxG.mouse.y > card.y && FlxG.mouse.y < card.y + card.height && FlxG.mouse.x > card.x && FlxG.mouse.x < card.x + card.width) //make sure its in bounds of the card
				{
					card.stamp(aStamp, Std.int(FlxG.mouse.x - card.x - aStamp.width/2), Std.int(FlxG.mouse.y - card.y - aStamp.height/3)); //this is better for overlapping edges but doesn't cover text
					approvalStamped = true;
				}
			}
			
			//likewise with killed and missing stamps
			else if (Registry.toolSelected == killedStamp && FlxG.mouse.justPressed && kStamped == false )
			{
				card.stamp(kStamp, Std.int(FlxG.mouse.x - card.x), Std.int(FlxG.mouse.y - card.y)); 
				kStamped = true;
			}
			
			else if (Registry.toolSelected == missingStamp && FlxG.mouse.justPressed && mStamped == false)
			{	
				card.stamp(mStamp, Std.int(FlxG.mouse.x - card.x), Std.int(FlxG.mouse.y - card.y)); 
				missingStamped = true;
			}		
			
		}
		
		else if (type == readOnly || type == citation)
		{
			
			if (card.dragging == true && Registry.toolSelected == move)
			{	
				card.x = FlxG.mouse.x - card.tempX;
				card.y = FlxG.mouse.y - card.tempY;
			}
		}
		
	}	
	
	private function clearStackBox():Void
	{
		Registry.stackBox.text = " ";
	}
	
	private function makeLogVisible (timer:FlxTimer) : Void
	{
		Registry.log.alpha = 1;
	}
	
	private function clearLog(timer:FlxTimer) 
	{
		Registry.log.alpha = 0;
	}

	public function feedback():Void 
	{
			
		//filtering to remove optional words from the whatCensored array
		//then sorting it into ascending order to make comparison easier
		whatCensored = sortArray(filterArray(whatCensored, optionalCensored));
		
		//approval stamp
		if (needsApproval == true && approvalStamped == false) 
		{
			Registry.feedback = "Failure. You did not stamp your approval on the postcard. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
		
		//approval stamp, REVERSE
		else if (needsApproval == false && approvalStamped == true)
		{
			Registry.feedback = "Failure. That postcard should not have been approved. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
		
		//KIA stamp
		else if (needsKilled == true && killedStamped == false) 
		{
			Registry.feedback = "Failure. You did not mark KILLED on the postcard. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
		
		//KIA stamp, REVERSE
		else if (needsKilled == false && killedStamped == true)
		{
			Registry.feedback = "Failure. You marked KILLED on the postcard unnecessarily. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
		
		//MIA stamp
		else if (needsMissing == true && missingStamped == false) 
		{
			Registry.feedback = "Failure. You did not mark MISSING on the postcard. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
		
		//MIA stamp REVERSE
		else if (needsMissing == false && missingStamped == true) 
		{
			Registry.feedback = "Failure. You marked MISSING on the postcard unnecessarily. Your prestige decreases.";
			updatePrestige(Registry.prestigeDecrement);
		}
			
		else if (Std.string(whatCensored) == Std.string(compareCensored))
		{
			Registry.feedback = "Successfly censored. Good work. Your prestige increases.";
			updatePrestige(Registry.prestigeIncrement);
		}
		
		else
		{
			updatePrestige(Registry.prestigeDecrement);
			
			////what was missed
			whatWasIncorrect = [];
			whatWasIncorrect = filterArray(whatCensored, compareCensored);
			whatWasMissed= [];
			whatWasMissed = filterArray(compareCensored, whatCensored);
			
			var x : Array<Int> = [ -4, -3, -2, -1, 0, 1, 2, 3]; //how many words other than the target word of the sentence our outputted
			var counter: Int = 1;
			
			Registry.feedback = "You failed; your prestige decreases. Details of your mistake below." + '\n';
			
			if (whatWasMissed.length > 0)
			{
				Registry.feedback = Registry.feedback + '\n' + 'You did not censor these sensitive words: ' + '\n'; 
				
				for (i in whatWasMissed) //this code runs through, outputtting what words were missed with the previous words in the sentence and the words afterwards
				{
					Registry.feedback = Registry.feedback + '\n' + counter + '. ';
					
					for (n in 0...x.length)
					{
						if (x[n] == 0)
						{
							Registry.feedback = Registry.feedback + ' >>' + buttons[i].text + '<< '; //markers to indicate >>censoredword<<, would be better UPPERCASE or BOLD
						}
						
						else {
							var y : Int = i + x[n]; //for cleanliness
							Registry.feedback = Registry.feedback + buttons[y].text + ' ';
						}
					}
					
					Registry.feedback = Registry.feedback + '\n';
					counter++;
				}
			}
			
			counter = 1;
			
			if (whatWasIncorrect.length > 0)
			{
				for (i in whatWasIncorrect) //same code as above but with different array
				{
					Registry.feedback = Registry.feedback + '\n' + 'You incorrectly censored these words: ' + '\n'; 
					Registry.feedback = Registry.feedback + '\n' + counter + '. ';
					
					for (n in 0...x.length)
					{
						if (x[n] == 0)
						{
							Registry.feedback = Registry.feedback + ' >>' + buttons[i].text + '<< ';
						}
						
						else {
							var y : Int = i + x[n]; //for cleanliness
							Registry.feedback = Registry.feedback + buttons[y].text + ' ';
						}
					}
					
					Registry.feedback = Registry.feedback + '\n';
					counter ++;
				}
			}
		}
	}	
	
	private function sortArray(a:Array<Int>):Array<Int> 
	{
		var b: Int = 0;
		var swaps: Bool = false;
		
		//4, 10, 5, 8, 2, 9
		
		while (swaps==false)
		{
			swaps = true;
			for (i in 0...a.length)
			{
				if (a[i - 1] > a[i])
				{
					b = a[i-1];
					a[i-1] = a[i];
					a[i] = b;
					swaps = true;
				}	
			}
		}
		
		return a;
	}

	
	private function filterArray(a:Array<Int>, b:Array<Int>):Array<Int>
	{
		var filtered:Array<Int>;
		filtered = [];
		var counter : Int = 0;
		
		var broken : Bool = false;
		
		for (i in 0...a.length) //filter through every number in the original array
		{
			broken = false;
			
			//for (n in 0...optionalCensored.length) //check if the number in the array, i, is the same as any in the optional number array
			for (n in 0...b.length)
			{
				if (b[n] == a[i]) { //if yes, then remove this from the filtered array
					broken = true;
					break;
				}
			}
			
			if (broken == false)
			{ //if no match, then add this number to the filtered
				filtered[counter] = a[i];
				counter++;
			}
		}
		
		return filtered;
	}

	private function updatePrestige (change:Int) : Void 
	{
		//updating prestige score
		Registry.prestigeScore = Registry.prestigeScore + change;
		Registry.prestigeCounter.text = Std.string(Registry.prestigeScore);
	}
	
	override public function destroy():Void
    {
		switch(type) {
			case censorable : {
				for (i in buttons)
				{
					i.destroy();
				}
				aStamp.destroy();
				kStamp.destroy();
				mStamp.destroy();
				template.destroy();
				canvas.destroy();
				
			}
			
			case readOnly : {
				
			}
			
			case citation : {
				readText.destroy();
			}
			
			card.destroy();
			
		}
		
		super.destroy();	
    }
	//this stamps a clear copy of the original image on top of the marked image
	public function clearStamps() : Void
	{
		card.stamp(template, 0, -3);
	}
	
	
	public function setVisible(TrueIsInvisible:Bool)
	{
		if (TrueIsInvisible)
		{
			card.alpha = 1;
			readText.alpha = 1;
		}
		else
		{
			card.alpha = 0;
			readText.alpha = 0;
		}
	}
	
}