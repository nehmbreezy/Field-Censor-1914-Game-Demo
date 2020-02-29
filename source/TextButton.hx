package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxColor;
import flixel.FlxG;

using flixel.util.FlxSpriteUtil;

class TextButton extends FlxText
{
	public var clicked : Bool;
	public var alreadyDone : Bool;
	public var storedX : Float;
	public var storedY : Float;
	public var stamped : Bool;
	
	public function new(X:Float, Y:Float, Width:Int, ?Text:String):Void
	{
		super(X, Y, Width, Text, 20);
		
		stamped = false;
		//storedX = 0;
		//storedY = 0;
		
		clicked = false;
		alreadyDone = false;
		
		//setup mouse events
		MouseEventManager.add(this, onClick, onFill2, onOver, onFill, true, true, false); //need to get rid of these 'nulls' for windows/mac platforms
	}
	
	private function onFill(object:FlxText):Void { }
	private function onFill2(object:FlxText):Void { }	
	
	override public function update():Void
	{	
		super.update();
	}
	
	private function onOver(object:FlxText):Void {
		if (FlxG.mouse.pressed && Registry.toolSelected == pencil)
		{
			censor();
		}
	}
	
	private function onClick(object:FlxText):Void{
		if (Registry.toolSelected == pencil) {
			censor();
		}
	}
	
	private function censor() {
		//color = FlxColor.MEDIUM_BLUE;
		clicked = true;
	}
	
	override public function destroy(): Void
	{
		MouseEventManager.remove(this);
		super.destroy();
	}
	
}

/*

Current challenges:

--then make the array and shit for longer letters

*/