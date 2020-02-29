package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;
/**
 * ...
 * @author Alexander
 */
class ToolSymbol extends FlxSprite
{
	public var toolType : Tool;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic, type:Tool) 
	{
		super(X, Y, SimpleGraphic);
		
		toolType = type;
		color = FlxColor.BLACK;
		
		MouseEventManager.add(this, onDown, null, onOver, onOut, false, true, false);
	}
	
	private function onDown(sprite:FlxSprite) 
	{
		
		if (toolType != rules)
		{
			Registry.toolSelected = toolType;
		}
		
		else if (toolType == rules && Registry.showRulebook == false)
		{
			Registry.showRulebook = true;
		}
		
		else if (toolType == rules && Registry.showRulebook == true)
		{
			Registry.showRulebook = false;
		}
		
		scale.x = 1;
		scale.y = 1;
	}
	
	private function onOver(sprite:FlxSprite)
	{
		color = FlxColor.BLACK;
		scale.x = 1.1;
		scale.y = 1.1;
	}
	
	private function onOut(sprite:FlxSprite)
	{
		color = FlxColor.BLACK;
		scale.x = 1;
		scale.y = 1;
	}
	
	override public function destroy():Void
    { 
        super.destroy();
    }
	
}