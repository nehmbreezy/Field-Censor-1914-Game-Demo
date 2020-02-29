package;

import flixel.text.FlxText;
import openfl.Assets;
import flixel.group.FlxGroup;

/**
 * Contains all the letter/postcard/text data for the game and puts it into cycleable arrays.
 * 
 * Here you can edit:
 * The starting x-y positions of the letter
 * 
 * 
 * @author Alexander
 */
class LetterData
{
	public var day1 : Array<LetterInfo>;
	public var day2 : Array<LetterInfo>;
	public var day3 : Array<LetterInfo>;
	public var day4 : Array<LetterInfo>;
	public var day5 : Array<LetterInfo>;
	public var day6 : Array<LetterInfo>;
	public var days : Array<Array<LetterInfo>>;
	public var daysTools : Array<Int>;
	public var rules : Array<String>;
	public var dayRules : Array<Int>;
	
	//starting positions for the letters
	private var censorX : Int;
	private var censorY : Int;
	private var instructX : Int;
	private var instructX2 : Int;
	private var instructY : Int;
	private var instructY2 : Int;
	
	
	public function new() 
	{	
		//starting positions
		censorX = 1500; //offscreen, basically
		censorY = 1200;
		instructX = 1400;
		instructX2 = 1400;
		instructY = 550;
		instructY2 = 550;
		
		//NOTE: DO NOT PUT ANY NUMBERS IN THE ARRAYS THAT ARE LARGER NUMBERS THAN THE TOTAL NUMBER OF WORDS IN THE LETTER TEXT. THIS CRASHES THE GAME WITH NO EXPLANATION.
		
		////******* DAY 1 *******//	
		////declaring day 1's instructs
		day1 = [];
		day1[0] = new LetterInfo (Assets.getText("assets/letterTexts/day1/1.txt"), readOnly);
		day1[1] = new LetterInfo (Assets.getText("assets/letterTexts/day1/2.txt"), readOnly);

		//declaring day 1's censorables
		day1[2] = new LetterInfo (Assets.getText('assets/letterTexts/day1/3.txt'), censorable);
		day1[3] = new LetterInfo (Assets.getText('assets/letterTexts/day1/4.txt'), censorable);
		day1[4] = new LetterInfo (Assets.getText('assets/letterTexts/day1/5.txt'), censorable);
		
		//******* DAY 2 *******//
		day2 = [];
		day2[0] = new LetterInfo(Assets.getText("assets/letterTexts/day2/1.txt"), readOnly);
		day2[1] = new LetterInfo(Assets.getText('assets/letterTexts/day2/2.txt'), censorable);
		day2[2] = new LetterInfo(Assets.getText('assets/letterTexts/day2/3.txt'), censorable);
		day2[3] = new LetterInfo(Assets.getText('assets/letterTexts/day2/4.txt'), censorable);
		day2[4] = new LetterInfo(Assets.getText('assets/letterTexts/day2/5.txt'), censorable);
		
		
		//******* DAY 3 *******//
		day3 = [];
		
		day3[0] = new LetterInfo(Assets.getText("assets/letterTexts/day3/1.txt"), readOnly);
		day3[1] = new LetterInfo(Assets.getText("assets/letterTexts/day3/2.txt"), censorable, true);
		day3[2] = new LetterInfo(Assets.getText("assets/letterTexts/day3/3.txt"), censorable, true);
		day3[3] = new LetterInfo(Assets.getText("assets/letterTexts/day3/4.txt"), censorable, true);
		day3[4] = new LetterInfo(Assets.getText("assets/letterTexts/day3/5.txt"), censorable, true);
		day3[5] = new LetterInfo(Assets.getText("assets/letterTexts/day3/6.txt"), censorable, true);
		
		//******* DAY 4 *******//
		day4 = [];
		
		day4[0] = new LetterInfo(Assets.getText("assets/letterTexts/day4/1.txt"), readOnly);
		//skipping two -- shop here?
		day4[1] = new LetterInfo(Assets.getText("assets/letterTexts/day4/3.txt"), censorable, true);
		day4[2] = new LetterInfo(Assets.getText("assets/letterTexts/day4/4.txt"), censorable, true);
		day4[3] = new LetterInfo(Assets.getText("assets/letterTexts/day4/5.txt"), censorable, true);
		day4[4] = new LetterInfo(Assets.getText("assets/letterTexts/day4/6.txt"), censorable, true);
		
		//******* DAY 5 *******//
		day5 = [];
		//stamping approval on envelopes instruct here
		
		day5[0] = new LetterInfo(Assets.getText('assets/letterTexts/day5/1.txt'), censorable, true);
		day5[1] = new LetterInfo(Assets.getText('assets/letterTexts/day5/2.txt'), censorable, true);
		day5[2] = new LetterInfo(Assets.getText('assets/letterTexts/day5/3.txt'), censorable, true);
		day5[3] = new LetterInfo(Assets.getText('assets/letterTexts/day5/4.txt'), censorable, true);
		day5[4] = new LetterInfo(Assets.getText('assets/letterTexts/day5/5.txt'), censorable, true);
		
		//******* DAYS *******//
		days = [day1, day2, day3, day4, day5];
		
		//rules and tools
		
		//put the taskData in here too
		rules = [];
		rules[0] = "Censor any specific place names, E.g Ypres.";
		rules[1] = "Stamp your unique censorship stamp on each letter after it has been censored.";
		rules[2] = "Censor any details, especially numbers, of wounded or killed soldiers.";
		
		dayRules = [1, 1, 2, 3, 3, 3];
		daysTools = [3, 3, 4, 4, 4, 4]; //which level of tools should be activated 
	}
	
}
