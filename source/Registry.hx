package;
import flixel.FlxSprite;
import nape.constraint.DistanceJoint;
import flixel.text.FlxText;

//Not everything has to go in here, just the objects that you need to either retain their
//content when you change state, or objects that you know you’ll need to 
//reference from elsewhere in your code, no matter how deep you get

//t’s a means for any object to gain access to another object or service, 
//regardless of its depth in your structure. Once you start planning and thinking in this way, 
//designing your game starts to become a lot easier. Your game objects can “share” knowledge of 
//the game without the need for passing references or instances

class Registry
{	
	public static var log:FlxText; //for showing censored words
	public static var stackBox:FlxText; //for stacking censored words
	
	public static var drawing : Bool;
	public static var prevMousePos : Array<Int>;
	public static var currentMousePos : Array<Int>;
	
	public static var card: Card;
	public static var cardJoint:DistanceJoint;
	
	public static var prestigeScore : Int;
	public static var prestigeIncrement : Int;
	public static var prestigeDecrement : Int;
	public static var prestigeCounter : FlxText;
	
	public static var letter1: Letter;
	public static var letterInstruct: Letter;
	
	public static var toolSelected : Tool;
	public static var toolbar : Toolbar;
	public static var showRulebook : Bool;
	
	public static var feedback : String;
	public static var citation : Letter;
	
	public static var testButton:TextButton; //filler, but necessary
	public static var addNewLetter : Bool;
}