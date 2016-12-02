package SO.Desktop 
{
	import SO.InitSO;
	
	import flash.utils.*;
	
	import flexlib.mdi.containers.MDICanvas;
	
	import mx.collections.ArrayCollection;
	/**
	 * ...
	 * @author FTeixeira
	 */
	public class BackgroundImage
	{
		
		[Bindable]
		[Embed(source='Background/brown.png')]
		private var brown:Class;
		
		[Bindable]
		[Embed(source='Background/doctor.png')]
		private var doctor:Class;
		
		[Bindable]
		[Embed(source='Background/family.png')]
		private var family:Class;
		
		[Bindable]
		[Embed(source='Background/Gnocity.png')]
		private var gnocity:Class;
		
		[Bindable]
		[Embed(source='Background/green.png')]
		private var green:Class;
		[Bindable]
		public var BackImages:ArrayCollection=new ArrayCollection;
		public function BackgroundImage(Workspace:MDICanvas) 
		{
			var Background:String=InitSO.CookieManager.gconf.get("background");
	
			var mc:Object;
			BackImages.addItem(new ImageProperties(brown,"Brown"));
			BackImages.addItem(new ImageProperties(family,"Family"));
			BackImages.addItem(new ImageProperties(gnocity,"Gnome City"));
			BackImages.addItem(new ImageProperties(green,"Green"));
			BackImages.addItem(new ImageProperties(doctor,"Doctor"));	
			switch(Background)
			{
				case "Brown":
						mc=brown;
					break;
				case "Doctor":
					mc=doctor;
					break;
				case "Family":
					mc=family;
					break;	
				case "Green":
					mc=green;
					break;
				case "Gnome City":
					mc=gnocity;
					break;
				default:
					mc=brown;
					
			}			
			
			Workspace.setStyle( "backgroundImage", mc);
			
		}
		
	}

}