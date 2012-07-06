package erazor.hscript;

import haxe.rtti.Meta;

class EnhancedReflect {
	
	public static function getProperty( o : Dynamic , field : String ){
		var v = Reflect.field( o , field );
		if( v != null ) return v;

		try{
			var meta = Meta.getFields( Type.getClass( o ) );
			var infos = Reflect.field( meta, field );
			if( infos != null ){
				var getter = infos.get;
				if( getter != null ) return Reflect.callMethod( o , Reflect.field( o , getter[0] ) , [] );
			}
		}catch(e:Dynamic){}

		try{
			var meta = Meta.getType( Type.getClass(o) );
			if( meta.resolve != null ){
				return Reflect.callMethod( o , Reflect.field( o , "resolve" ) , [ field ] );
			}
		}catch(e:Dynamic){}

		return null;
		
	}
}