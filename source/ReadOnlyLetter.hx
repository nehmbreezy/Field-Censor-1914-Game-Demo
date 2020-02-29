package;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
/**
 * @author Alexander
 * 
 * This class is for draggable letters e.g instruction letters, official
 * documents, citations, which don't need the drawing/censor-detection code.
 */
class ReadOnlyLetter extends FlxGroup
{
	public var text : FlxText;
	public var autoArchive : Bool;
	public var card : DraggableFlxSprite;
	private var template : FlxSprite;
	
	//private variables for setting the margins and font
	private var fontSize : Int;
	private var typewriterFont : Dynamic;
	private var rightMargin : Float;
	private var topMargin : Float;
	private var leftMargin : Float;
	
	public function new(X:Float=0, Y:Float=0, inputText:String, ?SimpleGraphic:Dynamic, ?TemplateGraphic:Dynamic) : Void
	{	
		super(5);
		
		card = new DraggableFlxSprite(X, Y, SimpleGraphic);
		template = new FlxSprite(0, 0, TemplateGraphic);
		add(card);
		
		autoArchive = false;
		
		leftMargin = 25;
		topMargin = 30;
		rightMargin = card.width - 100;
		typewriterFont = "assets/fonts/typewriter2.ttf"; 
		fontSize = 23; 
		
		
		initText(inputText);
	}
	
	public function initText(theText:String):Void 
	{
		text = new FlxText(leftMargin, topMargin, rightMargin, theText);
		text.setFormat(typewriterFont, fontSize, FlxColor.BLACK);
		add(text);
		
		card.stamp(text, Std.int(leftMargin), Std.int(topMargin));
		text.destroy();
	}
	
	override public function update() : Void {
		//text.x = card.x + leftMargin;
		//text.y = card.y + topMargin;
		
		//this is necessary because when in a group the draggableFlxSprite 
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
			//text.alpha = 1;
		}
		else
		{
			card.alpha = 0;
			//text.alpha = 0;
		}
	}
	
	public function setX(X:Float):Void {
		card.x = X;
	}
	
	public function setY(Y:Float):Void {
		card.y = Y;
	}
	
	public function clearStamps():Void {
		card.stamp(template, 0, 0);
	}
	
	public function resetText(finishX:Int,finishY:Int,text:String):Void {
		clearStamps();
		initText(text);
		card.x = finishX;
		card.y = finishY + 400;
		
		FlxTween.tween(card, { x: finishX, y:finishY }, 1, { ease: FlxEase.quadOut});
	}
	
	public function keepOffscreen():Void
	{
		card.x = -1000;
		card.y = 0;
	}
	
	public function exit():Void
	{
		Registry.addNewLetter = true;
		card.stamp(template, 0, 0);
		destroy();
		
		//tween goes here
	}
	
	override public function destroy():Void
	{
		card.destroy();
		template.destroy();
		super.destroy();
	}
	
}