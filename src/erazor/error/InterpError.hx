
package erazor.error;

class InterpError {

	public var pos (default, null): Script.Pos;
	public var err (default, null): hscript.Expr.Error;

	public function new( pos , err ){
		this.pos = pos;
		this.err = err;
	}

}