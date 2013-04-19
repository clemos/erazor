package erazor;

#if haxe3
typedef IntHash<T> = Map<Int,T>
#end

typedef Script = {
	src : String,
	map : IntHash<Pos>
}

typedef Pos = {
	start : Int,
	length : Int
}

typedef ParsedBlock = {
	var block : TBlock;
	var start : Int;
	var length : Int;
}

enum TBlock
{
	// Pure text
	literal(s : String);
	
	// Code
	codeBlock(s : String);
	
	// Code that should be printed immediately
	printBlock(s : String);
}