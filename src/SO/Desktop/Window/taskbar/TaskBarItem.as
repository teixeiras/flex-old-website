package SO.Desktop.Window.taskbar
{
	import flash.display.DisplayObject;
	
	import flexlib.mdi.containers.MDIWindow;

	
	[Bindable]
	public class TaskBarItem
	{	
		public var window : MDIWindow;
		public var label : String;
		public var icon:Class;
		
		public function TaskBarItem(label:String, window:MDIWindow, icon:Class):void
		{
			this.label = label;
			this.window = window;
			this.icon=icon;
		}
		
	}
}