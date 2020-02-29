package;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

import flixel.group.FlxGroup;

/**
 * ...
 * @author Alexander
 */
class Rulebook extends FlxGroup
{
	public var text : FlxText;
	public var card : DraggableFlxSprite;
	private var template : FlxSprite;
	public var isVisible : Bool;
	
	//private variables for setting the margins and font
	private var fontSize : Int;
	private var typewriterFont : Dynamic;
	private var rightMargin : Float;
	private var centreMargin : Float;
	private var topMargin : Float;
	private var leftMargin : Float;
	
	public function new(?SimpleGraphic:Dynamic, ?TemplateGraphic:Dynamic) 
	{
		super(10);
		
		var  X : Int = 300;
		var Y : Int = 200;
		
		card = new DraggableFlxSprite(X, Y, SimpleGraphic);
		template = new FlxSprite(0, 0, TemplateGraphic);
		add(card);
		
		leftMargin = 80;
		topMargin = 30;
		centreMargin = card.width / 2 - 120;
		rightMargin = card.width - 40;
		typewriterFont = "assets/fonts/typewriter2.ttf"; 
		fontSize = 23; 
		isVisible = false;
	}
	
	public function initText(theText:String):Void 
	{
		var tempText : String = 'RULES FOR SUCCESSFUL CENSORSHIP: ' + theText;
		
		text = new FlxText(leftMargin, topMargin, centreMargin, tempText);
		text.setFormat(typewriterFont, fontSize, FlxColor.BLACK);
		add(text);
		
		//something here about hitting the second margin/page
		
		card.stamp(text, Std.int(leftMargin), Std.int(topMargin));
		text.destroy();
	}
	
	override public function update():Void
	{
		if (card.dragging == true && Registry.toolSelected == move)
		{	
			card.x = FlxG.mouse.x - card.tempX;
			card.y = FlxG.mouse.y - card.tempY;
		}
	}
	
	public function setVisible(visible:Bool)
	{
		if (visible)
		{
			card.alpha = 1;
			isVisible = true;
		}
		else
		{
			card.alpha = 0;
			isVisible = false;
		}
	}
	
	public function initDailyRules(rules:Array<String>, limit:Int):Void
	{
		clearStamps();
		
		var tempText : String = '';
		for (i in 0...limit)
		{
			tempText = tempText + '\n' + '\n' + '${i+1}: ' + rules[i];
		}
		
		initText(tempText);
	}
	
	public function clearStamps():Void 
	{
		card.stamp(template, 0, 0);
	}
	
}