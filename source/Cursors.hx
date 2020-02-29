package;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG.mouse;
import flixel.FlxG;
import flixel.util.FlxColor;
/**
 * ...
 * @author Alexander
 */
class Cursors extends FlxGroup
{
	//the cursors
	private var pencilCursor : FlxSprite;
	private var moveCursor : FlxSprite;
	private var stampCursor : FlxSprite;
	private var moveCursor2 : FlxSprite;
	private var kStampCursor : FlxSprite;
	private var mStampCursor : FlxSprite;

	public function new() 
	{
		super(20);
		
		//kStamp cursor
		kStampCursor = new FlxSprite (0, 0, "assets/icons/killed_cursor.png");
		kStampCursor.alpha = 0;
		kStampCursor.color = FlxColor.BLACK;
		
		//mStamp Cursor
		mStampCursor = new FlxSprite (0, 0, "assets/icons/missing_cursor.png");
		mStampCursor.alpha = 0;
		add(mStampCursor);
		mStampCursor.color = FlxColor.BLACK;
		
		//pencil cursor
		pencilCursor = new FlxSprite(0, 0, "assets/icons/pencil_cursor.png");
		pencilCursor.alpha = 0;
		add(pencilCursor);
		pencilCursor.color = FlxColor.BLACK;
		
		//move cursor
		moveCursor = new FlxSprite(0, 0, "assets/icons/move_cursor.png");
		moveCursor.alpha = 0;
		add(moveCursor);
		moveCursor.color = FlxColor.BLACK;
		
		moveCursor2 = new FlxSprite(0, 0, "assets/icons/move_cursor2.png");
		moveCursor2.alpha = 0;
		add(moveCursor2);
		moveCursor2.color = FlxColor.BLACK;
		
		//stamp cursor
		stampCursor = new FlxSprite(0, 0, "assets/icons/stamp_cursor.png");
		add(stampCursor);
		stampCursor.color = FlxColor.BLACK;
	}
	
	override public function update() {
		super.update();

		pencilCursor.y = FlxG.mouse.y - pencilCursor.height + 5;
		pencilCursor.x = FlxG.mouse.x - 10;
		
		moveCursor.y = FlxG.mouse.y - moveCursor.height / 2; //making sure the cursor is centered on teh tool symbol
		moveCursor.x = FlxG.mouse.x - moveCursor.width / 2;
		
		stampCursor.y = FlxG.mouse.y - stampCursor.height / 2;
		stampCursor.x = FlxG.mouse.x - stampCursor.width / 2;	
		
		moveCursor2.y = FlxG.mouse.y - moveCursor2.height / 2;
		moveCursor2.x = FlxG.mouse.x - moveCursor2.width / 2;
		
		mStampCursor.x = FlxG.mouse.x - mStampCursor.width / 2;
		mStampCursor.y = FlxG.mouse.y - mStampCursor.height / 2;
		
		kStampCursor.x = FlxG.mouse.x - kStampCursor.width / 2;
		kStampCursor.y = FlxG.mouse.y - kStampCursor.height / 2;
		
		if (Registry.cardJoint != null) {
			showOnlyCursor(moveCursor2);
		}
		
		else { 
			switch(Registry.toolSelected)
			{
				case pencil : {
					showOnlyCursor(pencilCursor);
				}
				case move : {
					showOnlyCursor(moveCursor);
				}
				case stamp : {
					showOnlyCursor(stampCursor);
				}
				
				case killedStamp : {
					showOnlyCursor(kStampCursor);
				}
				
				case missingStamp : {
					showOnlyCursor(mStampCursor);
				}
				
				default : {
					showOnlyCursor(moveCursor);
				}
				
			}
		}
		
	}
	
	private function showOnlyCursor(cursor:FlxSprite): Void
	{
		pencilCursor.alpha = 0;
		moveCursor.alpha = 0;
		stampCursor.alpha = 0;
		moveCursor2.alpha = 0;
		kStampCursor.alpha = 0;
		mStampCursor.alpha = 0;
		
		cursor.alpha = 1;
	}
	
	override public function destroy() {
		kStampCursor.destroy();
		pencilCursor.destroy();
		moveCursor.destroy();
		moveCursor2.destroy();
		stampCursor.destroy();
		mStampCursor.destroy();
		
		super.destroy();
	}
	
	public function hideCursor():Void {
		pencilCursor.alpha = 0;
		moveCursor.alpha = 0;
		stampCursor.alpha = 0;
		moveCursor2.alpha = 0;
		kStampCursor.alpha = 0;
		mStampCursor.alpha = 0;
	}
	
}