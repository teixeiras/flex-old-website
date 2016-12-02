package Plugins.ConsoleCmd
{
	public class Directory 
	{
		private var list:Array;
		private var Name:String;

		public function Directory(Name:String=null)
		{
			if(Name==null)
				return;
			list=new Array;
			this.Name=Name;	
		}
		public  function toString():String
		{
			var str:String=new String();
			str+=this.Name;
			for(var i:uint=0;i<list.length;i++)
			{
				str+="\n\t"+list[i].toString();	
			}
			return str;
		} 
		public function addDirectory(f:Directory):Directory
		{
			return (list[list.length]=f);
			
		}
		public function addFile(f:File):File
		{
			return (list[list.length]=f);
			
		}
		
		
	}

}