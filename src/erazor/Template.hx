package erazor;

import hscript.Expr.Error;
import hscript.Interp;
import erazor.hscript.EnhancedInterp;

/**
 * Can be any object with properties or a Hash.
 */
typedef PropertyObject = Dynamic;

class Template
{
	private var template : String;
	
	public var variables(default, null) : Hash<Dynamic>;
	var script : erazor.Script;
	var program : hscript.Expr;

	@macro static function enablePos(){
		#if macro
			haxe.macro.Compiler.define("erazorPos");
			haxe.macro.Compiler.define("hscriptPos");
		#end
	}
	
	public function new( template : String )
	{

		this.template = template;
		
		var parsedBlocks = new Parser().parse(template);
		
		// Make a hscript with the buffer as context.
		script = new ScriptBuilder('__b__').build(parsedBlocks);
		
		// Make hscript parse and interpret the script.
		var parser = new hscript.Parser();
		
		#if erazorPos
			try{
				program = parser.parseString( script.src );
			}catch( e : hscript.Expr.Error ){
				throw hscriptError( e );
			}
		#else
			program = parser.parseString( script.src );
		#end

		
	
	}

	public dynamic function escape( str ){
		return str;
	}
	
	public function execute(?content : PropertyObject) : String
	{
		var buffer = new Output(escape);
			
		var interp = new EnhancedInterp();
		
		variables = interp.variables;
		
		var bufferStack = [];
		
		setInterpreterVars(interp, content);
		interp.variables.set('__b__', buffer); // Connect the buffer to the script
		interp.variables.set('__string_buf__', function(current) {
			bufferStack.push(current);
			return new StringBuf();
		});
		
		interp.variables.set('__restore_buf__', function() {
			return bufferStack.pop();
		});
		
		#if erazorPos
			try{
				interp.execute(program);
			}catch( e : hscript.Expr.Error ){
				throw hscriptError( e );
			}
		#else
			interp.execute(program);
		#end

		// The buffer now holds the output.
		return buffer.toString();
	}

	#if erazorPos 
	private function hscriptError( e : Error ){
		
		var prev = 0;
		for( k in script.map.keys() ){
			if( k > e.pmin ){
				break;
			}
			prev = k;
		}

		var pos = script.map.get(prev);
		var msg = switch( e.e ){
			case EUnexpected( str ) : 
				if( str == "__b__" ) {
					"Missing semi-colon (;)";
				}else{
					"Unexpected " + str;
				}
			default : Std.string(e.e);
		}
		return new erazor.error.InterpError( pos , msg );
		
	}
	#end
	
	private function setInterpreterVars(interp : Interp, content : PropertyObject) : Void
	{
		if(Std.is(content, Hash))
		{
			var hash : Hash<Dynamic> = cast content;
			
			for(field in hash.keys())
			{
				interp.variables.set(field, hash.get(field));
			}
		}
		else
		{
			for(field in Reflect.fields(content))
			{
				interp.variables.set(field, Reflect.field(content, field));
			}
		}
	}
}