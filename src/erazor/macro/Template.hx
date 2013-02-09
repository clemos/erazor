package erazor.macro;

/**
 * ...
 * @author Waneck
 */

@:autoBuild(erazor.macro.Build.buildTemplate())
class Template<T>
{
	public function new()
	{

	}

	public dynamic function escape( str : String ) : String 
		return str
	

#if display
	public function execute(context:T):String
	{
		return null;
	}
#end
}