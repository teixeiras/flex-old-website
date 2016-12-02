// ActionScript file

package
{
	import Plugins.ConsoleCmd.*;
	
	import SO.Desktop.Window.WindowsBase;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	
	public class Console extends WindowsBase
	 {
	 
	 private var input:TextInput;
	 private var Topic:String="teixeira@WebMedia:#";
	 private var cmd:String="";
	 
	 public function Console()
	 {

	 	this.setStyle("horizontalGap","0");
	 	this.setStyle("verticalGap","0");
	 	 
	 
	 	this.input=new TextInput();

	 
	 	this.input.addEventListener(KeyboardEvent.KEY_DOWN, Enter);
	 	this.addChild(input);
	 	this.input.percentHeight=100;
	 	this.input.percentWidth=100;
	 	
	 	this.percentHeight=100;
	 	this.percentWidth=100;
	 	
	 	this.input.setStyle("backgroundColor","black");
	 	this.input.setStyle("color","white");
	 	this.input.setStyle("borderThickness","0");
	 	this.input.setStyle("borderColor","black");
		this.input.editable=false;
	 	this.input.text+=Topic;
	 	
	 }
	 public static function  getName():String
	 {
	 		return "Console";
	 }
	 public function Submit():void
	 {
	 	
	 	Commands.Output(Commands.Factory(cmd),this.input);
	 	this.input.text+="\n"+Topic;
		this.input.selectionBeginIndex=this.input.length;
		this.input.selectionEndIndex=this.input.length;
		cmd="";
	 	
	 }
	 public function addTecla(caracter:uint):void
	 {
	 	input.text+=String.fromCharCode(caracter);
	 	cmd+=String.fromCharCode(caracter);
	 }	 
	 public function Enter(evt:KeyboardEvent):void
	 {
	 	if(evt.keyCode == Keyboard.ENTER)
	 		this.Submit();		
	 else
	 		this.addTecla(evt.charCode);
	 			
	 }
	 
	}
}