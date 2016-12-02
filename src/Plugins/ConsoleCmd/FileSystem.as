package Plugins.ConsoleCmd
{
	public class FileSystem 
	{
		private var files:Array;
		public function FileSystem()
		{
			files=new Array();
			
			var ac:Directory=this.AddDirectory(null,"etc");
			this.AddFile(ac,"teste");
			this.AddFile(ac,"uia");
			var caes:Directory=this.AddDirectory(ac,"caes");
			this.AddFile(caes,"raios");
			
		}
		public function list():String
		{
			
			var str:String=new String();
			str="\nList Files\n";
			for(var i:uint=0;i<files.length;i++)
				str+="*"+files[i].toString()+"\n";		
			return str;
		}
		
		
		public function AddFile(parent:Directory,name:String):File
		{
			if(parent!=null)
			return (parent.addFile(new File(name)));
			else
			return (this.files[this.files.length]=new File(name)); 
		}
		
		public function AddDirectory(parent:Directory,name:String):Directory
		{
			if(parent!=null)
			return (parent.addDirectory(new Directory(name)));
			else
			return (this.files[this.files.length]=new Directory(name));
		}

	}
}