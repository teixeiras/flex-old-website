package SO.Pipes
{
	
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ArrayUtil;
	
	public class DirectoryQuery extends Query
	{
		
		public function DirectoryQuery() 
		{
			super("photos.GetPhotos");
		
			this.getOperation("getHello",function(event:ResultEvent):void
		            							{
		            							
		            							},
		            							function(event:ResultEvent):void
		            							{
		            								
		            							
		            							});
			   
		}

	}
}