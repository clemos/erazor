
package erazor.error;

class InterpError {

	public var pos (default, null): Script.Pos;
	public var err (default, null): hscript.Expr.ErrorDef;

	public function new( pos , err ){
		this.pos = pos;
		this.err = err;
	}

}