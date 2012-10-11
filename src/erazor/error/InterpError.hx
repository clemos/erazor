
package erazor.error;

class InterpError {

	public var pos (default, null): Script.Pos;
	public var msg (default, null): String;

	public function new( pos , msg ){
		this.pos = pos;
		this.msg = msg;
	}

}