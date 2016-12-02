package Plugins.ConsoleCmd
{
	public class ConsoleLs extends Commands
	{
		
		public function ConsoleLs(args:Array)
		{
			
		}
		override public function execute():String
		{
			return Commands.fs.list();
		}

	}
}