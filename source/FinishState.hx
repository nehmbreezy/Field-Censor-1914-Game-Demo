package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Alexander
 */
class FinishState extends FlxState
{
	private var scoreText : FlxText;

	override public function create() : Void
	{
		scoreText = new FlxText(0, 0, 0, ' ', 40);
		scoreText.setFormat('assets/fonts/typewriter2.ttf', 40, FlxColor.WHITE);
		scoreText.text = 'Congratulations, you completed the demo of the game.' + '\n' + 'You scored ${Registry.prestigeScore} points out of a total of 19.' + ' Well done.';
		add(scoreText);
		
		super.create();
	}
	
	override public function update() {
		super.update();
	}
	
	override public function destroy() {
		scoreText.destroy();
		super.destroy();
	}
	
}