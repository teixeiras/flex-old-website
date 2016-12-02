package com.nbilyk.display {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.StyleSheet;
	
	import mx.controls.Text;
	
	[Event(name="sourceLoaded", type="flash.events.Event")]
	[Event(name="badResponse", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	public class GeshiTextField extends Text {
		public static const SOURCE_LOADED:String = "sourceLoaded";
		public static const BAD_RESPONSE:String = "badResponse";
		
		private var _serviceUrl:String;
		private var _source:String;
		private var _language:String = "actionscript3";
		private var isBusy:Boolean;
		
		// Validation flags
		private var sourceIsValid:Boolean;
		
		public function GeshiTextField() {
			super();
		}
		
		//-----------------------------------
		// Validation / invalidation 
		//-----------------------------------
		
		override protected function commitProperties():void {
			super.commitProperties();
			if (!sourceIsValid) validateSource();
		}
		
		public function invalidateSource():void {
			sourceIsValid = false;
			invalidateProperties();
		}
		
		private function validateSource():void {
			if (isBusy || !serviceUrl) return;
			sourceIsValid = true;
			isBusy = true;
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(serviceUrl);
			urlRequest.method = URLRequestMethod.POST;
			var data:URLVariables = new URLVariables();
			data.source = source;
			data.language = language;
			urlRequest.data = data;
			urlLoader.addEventListener(Event.COMPLETE, sourceLoadedHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, bubbleEventHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, bubbleEventHandler);
			urlLoader.load(urlRequest);
		}
		
		private function sourceLoadedHandler(event:Event):void {
			isBusy = false;
			var urlLoader:URLLoader = URLLoader(event.target);
			var geshiXml:XML;
			try {
				geshiXml = new XML(urlLoader.data);
				htmlText = geshiXml.source;
				
				if (styleSheet) {
					styleSheet.clear();
					styleSheet = null;
					validateNow();
				}
				
				var css:String = geshiXml.styles;
				var stylesSlit:Array = css.split("." + language + " ");
				css = stylesSlit.join("");
				css += " a:hover { text-decoration: underline; } ";
				
				var newStyleSheet:StyleSheet = new StyleSheet();
				newStyleSheet.parseCSS(css);
				styleSheet = newStyleSheet;
				
				dispatchEvent(new Event(SOURCE_LOADED));
			} catch (e:Error) {
				dispatchEvent(new Event(BAD_RESPONSE));
			}
		}
		
		private function bubbleEventHandler(event:Event):void {
			dispatchEvent(event);
		}
		
		//-----------------------------
		// Getters / setters
		//-----------------------------
		
		public function get serviceUrl():String {
			return _serviceUrl;
		}
		
		public function set serviceUrl(value:String):void {
			if (_serviceUrl == value) return; // no-op
			_serviceUrl = value;
			invalidateProperties();
		}
		
		public function get source():String {
			return _source;
		}
		
		public function set source(value:String):void {
			if (value == _source) return; // no-op
			_source = value;
			invalidateSource();
		}
		
		[Inspectable(enumeration="4cs,abap,actionscript,actionscript3,ada,apache,applescript,apt_sources,asm,asp,autohotkey,autoit,avisynth,awk,bash,basic4gl,bf,bibtex,blitzbasic,bnf,boo,c,c_mac,caddcl,cadlisp,cfdg,cfm,cil,clojure,cmake,cobol,cpp,cpp-qt,csharp,css,cuesheet,d,dcs,delphi,diff,div,dos,dot,eiffel,email,erlang,fo,fortran,freebasic,fsharp,gambas,gdb,genero,gettext,glsl,gml,gnuplot,groovy,haskell,hq9plus,html4strict,idl,ini,inno,intercal,io,java,java5,javascript,jquery,kixtart,klonec,klonecpp,latex,lisp,locobasic,logtalk,lolcode,lotusformulas,lotusscript,lscript,lsl2,lua,m68k,make,mapbasic,matlab,mirc,mmix,modula3,mpasm,mxml,mysql,newlisp,nsis,oberon2,objc,ocaml,ocaml-brief,oobas,oracle11,oracle8,pascal,per,perl,perl6,php,php-brief,pic16,pike,pixelbender,plsql,povray,powerbuilder,powershell,progress,prolog,properties,providex,purebasic,python,qbasic,rails,rebol,reg,robots,rsplus,ruby,sas,scala,scheme,scilab,sdlbasic,smalltalk,smarty,sql,systemverilog,tcl,teraterm,text,thinbasic,tsql,typoscript,vb,vbnet,verilog,vhdl,vim,visualfoxpro,visualprolog,whitespace,whois,winbatch,xml,xorg_conf,xpp,z80")]
		public function get language():String {
			return _language;
		}
		
		public function set language(value:String):void {
			if (value == _language) return; // no-op
			_language = value;
			invalidateSource();
		}

	}
}