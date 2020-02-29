package;

import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;

/**
 * This is to replace the Nape Draggable FlxSprite.
 * @author Alexander
 */
class DraggableFlxSprite extends FlxSprite
{
	public var mouseOver : Bool;
	public var dragging : Bool;
	
	public var tempX : Float;
	public var tempY : Float;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		mouseOver = false;
		dragging = false;
		
		MouseEventManager.add(this, onDown, onUp, onOver, onOut, true);
	}
	
	private function onDown(sprite:FlxSprite)
	{
		dragging = true;
		
		if (FlxG.mouse.justPressed)
		{
			tempX =  FlxG.mouse.x - this.x;
			tempY = FlxG.mouse.y - this.y;
		}	
	}
	
	private function onUp(sprite:FlxSprite)
	{
		dragging = false;
	}
	
	private function onOver(sprite:FlxSprite)
	{
		mouseOver = true;
	}
	
	private function onOut(sprite:FlxSprite)
	{
		mouseOver = false;
	}
	
	override public function update():Void
	{
		if (dragging == true && Registry.toolSelected == move)
		{	
			this.x = FlxG.mouse.x - tempX;
			this.y = FlxG.mouse.y - tempY;
		}
	}
	
	override public function destroy():Void {
		MouseEventManager.remove(this);
		super.destroy();
	}
}