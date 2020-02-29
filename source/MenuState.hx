package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxColor; 
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;


/**
 * @author Alexander
 * 
 *  This is the menu screen. Right now it's just going to be a simple button with a background image.
 * 
 *  Ideally the start button would be on a piece of paper which you could censor/stamp. It could even be a kind of tutorial. A cool one.
 */
class MenuState extends FlxState
{
	private var titleGraphic : FlxSprite;
	private var startTimer:FlxTimer;
	private var loadingText : FlxText;
	
	override public function create():Void
	{
		super.create();
		
		//FlxG.mouse.visible = false;
		
		var X : Float = FlxG.stage.width / 2 - 40;
		var Y : Float = FlxG.stage.height / 3;
		
		titleGraphic = new FlxSprite(0, 0, 'assets/title_graphic.png');
		titleGraphic.x = X;
		titleGraphic.y = -300;
		
		add(titleGraphic);
		FlxTween.tween(titleGraphic, { x: X, y: Y*0.7 }, 0.7, { ease:FlxEase.expoIn, complete: playStampSoundandProceed } );
		
		loadingText = new FlxText (X+10, Y*1.3, 0, 'LOADING...', 40, true);
		loadingText.setFormat('assets/fonts/typewriter1.ttf', 40, FlxColor.WHITE);
				
	}
	
	private function playStampSoundandProceed(tween:FlxTween):Void {
		add(loadingText);
		startTimer = new FlxTimer(0.2, switchToPlayState);
		
		//play sound here, however that's done.
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	override public function destroy(): Void
	{
		titleGraphic.destroy();
		loadingText.destroy();
		startTimer.destroy();
		
		super.destroy();
	}
	
	private function switchToPlayState(timer:FlxTimer): Void
	{
		FlxG.switchState(new PlayState());
	}
	
}