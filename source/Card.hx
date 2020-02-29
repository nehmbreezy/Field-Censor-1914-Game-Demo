package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxG.keys;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;


//This Card class basically = Draggable FlxSprite with a graphic

class Card extends FlxNapeSprite
{
	public var mouseOver : Bool;
	public var dragging : Bool;

	public function new(X:Int, Y:Int, Graphic:Dynamic):Void
	{
		super(X,Y);
		loadGraphic(Graphic);
		
		mouseOver = false;
		dragging = false;
		
		antialiasing = true;
		
		createRectangularBody();
		
		// To make sure cards don't interact with each other
		body.setShapeFilters(new InteractionFilter(2, ~2));
		
		// Setup the mouse events
		MouseEventManager.add(this, onDown, null, onOver, onOut);
		
	}
	
	private function onDown(Sprite:FlxSprite)
	{
		if (Registry.toolSelected == move) {
			
			dragging = true;
		
			var body:Body = cast(Sprite, FlxNapeSprite).body;
		
			Registry.cardJoint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(FlxG.mouse.x, FlxG.mouse.y),
				body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
							
			Registry.cardJoint.stiff = true;
			Registry.cardJoint.space = FlxNapeState.space;
			
			body.allowRotation = false;
		}
	}
	
	
	private function onOver(Sprite:FlxSprite) 
	{
		color = FlxColor.WHITE; //no color change for now
		mouseOver = true;
	}
	
	private function onOut(Sprite:FlxSprite)
	{
		color = FlxColor.WHITE;
		mouseOver = false;
	}
	
	override public function destroy():Void 
	{
		// Make sure that this object is removed from the MouseEventManager for GC
		MouseEventManager.remove(this);
		super.destroy();
	}
}
