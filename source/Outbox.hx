package;

import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;
import flixel.util.FlxColor;


/**
 * ...
 * @author Alexander
 */
class Outbox extends FlxSprite
{
	public var mouseOver : Bool;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		color = FlxColor.BLACK;
		MouseEventManager.add(this, onDown, null, onOver, onOut, false, true, false);
		shrink();
	}
	
	private function onDown(sprite:FlxSprite) 
	{	
	}
	
	private function onOver(sprite:FlxSprite)
	{	
		mouseOver = true;
	}
	
	private function onOut(sprite:FlxSprite)
	{
		mouseOver = false;
		shrink();
	}
	
	override public function destroy():Void
    { 
        super.destroy();
    }
	
	public function grow():Void {
		color = FlxColor.BROWN;
	}
	
	public function shrink():Void {
		color = FlxColor.BLACK;
	}
}