package erazor;

import erazor.Script;
private typedef Block = ParsedBlock;

class ScriptBuilder
{
	private var context : String;

	public function new(context : String)
	{
		this.context = context;
	}
	
	public function build(blocks : Array<Block>) : Script
	{
		var map = new IntHash();
		var buffer = new StringBuf();
		var pos = 0;
		var str = "";
		
		for(block in blocks)
		{
			
			map.set( pos , { start : block.start , length : block.length } );
			str = blockToString(block);
			buffer.add(str);
			pos += str.length;
		}

		return {
			map : map,
			src : buffer.toString()
		}
	}
	
	public function blockToString(block : Block) : String
	{
		var o = null;
		switch(block.block)
		{
			case literal(s):
				o = context + ".add('" + StringTools.replace(s, "'", "\\'") + "');";
			
			case codeBlock(s):
				o = s+"\n";
			
			case printBlock(s):
				o = context + ".unsafeAdd(" + s + ");";
		}
		return o;	
	}
}