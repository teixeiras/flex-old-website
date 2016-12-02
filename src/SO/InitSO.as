package SO 
{
	import SO.Desktop.BackgroundImage;
	import SO.Desktop.Window.applets.DesktopManager;
	import SO.gconf.InitCookie;
	
	import flexlib.mdi.containers.MDICanvas;
	import flexlib.mdi.containers.MDIWindow;
	
	import mx.collections.ArrayCollection;
	import mx.controls.SWFLoader;
	/**
	 * ...
	 * @author FTeixeira
	 */
	public class InitSO
	{
		public static  var screeny:SWFLoader;
		[Bindable]
		public static var taskBarItems : ArrayCollection;
		[Bindable] 
		public static var CookieManager:InitCookie=new InitCookie();
		[Bindable]
		public static var BI:BackgroundImage;
		[Bindable]
		public static var desktopManager:DesktopManager;
		
		public static var WorkSpace:MDICanvas;
		
		public function InitSO(WorkSpace:MDICanvas, desktopManager:DesktopManager) 
		{
			InitSO.desktopManager=desktopManager;
			BI = new BackgroundImage(WorkSpace);
			InitSO.WorkSpace=WorkSpace;
			screeny=desktopManager.screen1;				
			 taskBarItems  = desktopManager.taskBarItems1;
			 
		}
		public static function updateBackground():void
		{
			BI = new BackgroundImage(WorkSpace);
		}
		
	}

}