// ActionScript file
package Plugins.ConsoleCmd
{
	import mx.controls.TextInput;
	
	public class Commands
	{
		public static var fs:FileSystem=new FileSystem();
		
		public static function Factory(args:String):Commands
		{
			var cl:Array=args.split(" ");
			
			switch(cl[0])
			{
				case "ls":
					return new ConsoleLs(cl);
				break;
				default:
					return new NullCommand();
				break;
			}	
			
		}
		public function execute():String
		{
			return "\nNone";
		}
		public static function Output(cmd:Commands, text:TextInput):void
		{
			text.text+=cmd.execute();
		}
	}
}