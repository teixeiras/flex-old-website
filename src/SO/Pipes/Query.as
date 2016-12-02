package SO.Pipes
{
	import mx.controls.Alert;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

	public class Query
	{
		
		
		public var service:RemoteObject;
		public function Query(nService:String )
		{
			var url:String = Main.PATH+"webservices/gateway.php";
			var channel:AMFChannel = new AMFChannel("my-amfphp", url);
			var channelSet:ChannelSet = new ChannelSet();
			channelSet.addChannel(channel);
			service = new RemoteObject("amfphp");
			service.channelSet = channelSet;
			// Specify the PHP class
			service.source = nService;
		
			// the TestService class must have a public helloWorld function
		}
		public function getOperation(proc:String , fail:Function, success:Function):void
		{
			
				service.addEventListener(FaultEvent.FAULT, fail);
				service.addEventListener(ResultEvent.RESULT, success );
				service.getOperation(proc).send();
		}


	}
}