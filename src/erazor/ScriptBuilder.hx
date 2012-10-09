﻿package erazor;

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

		switch(block.block)
		{
			case literal(s):
				return context + ".add('" + StringTools.replace(s, "'", "\\'") + "'); // "+block.start+","+block.length+"\n";
			
			case codeBlock(s):
				return s + " // "+block.start+","+block.length+"\n";
			
			case printBlock(s):
				return context + ".add(" + s + "); // "+block.start+","+block.length+"\n";
		}
	}
}