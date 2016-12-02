package SO.Desktop
{
	public class ImageProperties
	{
			public var icon:Object;
			public var label:String;	
			public function ImageProperties(Image:Object,Name:String)
			{
				this.label=Name;
				this.icon=Image;
			}

	}
}