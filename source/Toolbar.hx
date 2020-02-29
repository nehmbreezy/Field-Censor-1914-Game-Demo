package;

import flixel.group.FlxGroup;
import nape.callbacks.InteractionType;

/**
 * This class stores all the toolbar stuff. Displays stuff based on which level/day it is needed
 * @author Alexander
 */
class Toolbar extends FlxGroup
{	
	public var tools : Array<ToolSymbol>;
	
	//for the toolbar settings
	private var yStart :Int;
	private var xStart: Int;
	private var yOffset: Int;
	private var _limit: Int;
	
	//the toolbar tool buttons
	private var rulebook : ToolSymbol;
	private var pencilTool : ToolSymbol;
	private var moveTool : ToolSymbol;
	private var stampTool : ToolSymbol;
	private var kStampTool: ToolSymbol;
	private var mStampTool: ToolSymbol;

	public function new() 
	{
		super(20);
		
		yStart = 50; //position variables for populating the toolbar
		yOffset = 50;
		xStart = 50;
		
		tools = []; //declaring the array
		
		rulebook = new ToolSymbol(-100, -100, 'assets/icons/rulebook.png', rules); 
		moveTool = new ToolSymbol(0, 0, 'assets/icons/move_cursor.png', move);
		pencilTool = new ToolSymbol(0, 0, 'assets/icons/pencil_cursor.png', pencil);
		stampTool = new ToolSymbol(-100, -100, 'assets/icons/stamp_cursor.png', stamp);
		kStampTool = new ToolSymbol(-100, -100, "assets/icons/killed_cursor.png", killedStamp);
		mStampTool = new ToolSymbol (-100, -100, "assets/icons/missing_cursor.png", missingStamp);
		
		tools[0] = rulebook;
		tools[1] = moveTool; 
		tools[1].alpha = 0;
		tools[2] = pencilTool;
		tools[2].alpha = 0;
		tools[3] = stampTool; 
		tools[3].alpha = 0;
		tools[4] = kStampTool;
		tools[4].alpha = 0;
		tools[5] = mStampTool;
		tools[5].alpha = 0;
	}
	
	public function populate(limit:Int) : Void // up to a limit 
	{
		yStart = 50;
		var count : Int = 0;
		_limit = limit;
		
		if (limit > tools.length)
		{
			//this is an error
			Registry.log.text = 'Error! Limit too large';
		}
		
		else {
			
			var count : Int = 1;
			
			for (n in 0...limit)
			{
				if (n == 0)
				{
					tools[n].x = xStart;
					tools[n].y = yStart;
					
				}

				else
				{
					tools[n].x = xStart;
					yStart = yStart + Std.int(tools[n - 1].height) + yOffset;
					tools[n].y = yStart;
					
				}
				
				add(tools[n]);
				tools[n].alpha = 1;
				count++;
			}
		}
		
		
	}

	public function clearToolbar():Void
	{
		for (n in 0..._limit)
		{
			remove (tools[n]);
		}
	}
}