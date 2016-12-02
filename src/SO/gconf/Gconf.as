package SO.gconf 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author FTeixeira
	 */
	public class Gconf
	{
		public var Conf:SharedObject= SharedObject.getLocal("SoDef");
		
		public function Gconf() 
		{
			
		}
		public function addOrUpdate(key:String, value:String):void
		{
			Conf.data[key] = value;
		}
		public function get(key:String):String
		{
			return Conf.data[key];
		}
		
	}

}