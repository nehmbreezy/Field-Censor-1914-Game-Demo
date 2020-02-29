package;

import flixel.group.FlxGroup;

/**
 * Here's an Idea:
 * 
 * What do I really need from the letterdata array? What INFO?
 * 
 * The text 1
 * The type of letter 2
 * The background image 3
 * 
 * LetterData can be a lot more simple.
 * 
 * The letterconstructor class can build readOnly letters very very easily.
 * It can build censorableLetters too but it's a little more complicated.
 * 
 * The only issue is having multiple letters on-screen. Which is not even necessary, really.
 * 
 * I only need one letterConstructor. 
 * 
 * @author Alexander
 */
class LetterConstructor extends FlxGroup
{

	public function new() 
	{
		
	}
	
}