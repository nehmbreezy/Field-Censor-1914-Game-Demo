package;

class StringIterator
{
	private var str:String;
	private var i:Int;

	public function new(str:String) 
	{
		this.str = str;
		i = 0;
	}
	
	public function hasNext():Bool {
		return i < str.length;
	}
	
	public function next():String {
		return str.charAt(i++);
	}
}