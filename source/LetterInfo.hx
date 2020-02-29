package;

/**
 * ...
 * @author Alexander
 */
class LetterInfo
{
	public var text : String;
	public var type : LetterType;
	public var needsApproval : Bool;
	public var needsKilled : Bool;
	public var needsMissing : Bool;
	
	public function new(Text:String, letterType: LetterType, ?approval:Bool=false,?killed:Bool=false,?missing:Bool=false) 
	{
		text = Text;
		type = letterType;
		needsApproval = approval;
		needsKilled = killed;
		needsMissing = missing;
	}
	
}