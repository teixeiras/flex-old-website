package Plugins.ConsoleCmd
{
	public class File extends Directory
	{
		private var Name:String;
		public function File(Name:String)
		{
			this.Name=Name;
			
		}
		override public  function toString():String
		{
			return this.Name;
		}
	}

}