// ActionScript file
package Plugins.dEffects
{
import SO.Desktop.Window.applets.Stopped;
import SO.InitSO;

import away3d.containers.View3D;
import away3d.core.math.Number3D;
import away3d.lights.AmbientLight3D;
import away3d.primitives.Cube;
import away3d.primitives.data.CubeMaterialsData;

import flash.events.*;
import flash.utils.*;
import mx.core.FlexGlobals;
import mx.core.UIComponent;


public class FlexView3D extends UIComponent{
         

        private var view:View3D;
        private var sceneLight:AmbientLight3D;
		private var mat:CubeMaterialsData;
		private var rot:uint=0;
		private var can_rotate:Boolean=true;
        //Test
        private var deskCube:Cube;

        public function FlexView3D(mat:CubeMaterialsData):void
        {
      		this.mat=mat;
            this.addEventListener(Event.ENTER_FRAME, onFrameEnter);
            this.percentHeight=100;
            this.percentWidth=100;
        }
        private function onTimer(event:TimerEvent):void
        {
    			this.deskCube.rotate(new Number3D(0,1,0),1);
				this.view.render();
	    }

		private function  uncheck(event:TimerEvent):void
        {
    		this.can_rotate=true;
    		FlexGlobals.topLevelApplication.dispatchEvent(new Stopped("finished"));
	    }

		private function check():void
        {
    		this.can_rotate=false;
	    }

		public function goTo(i:uint):void
		{
		
		
			if(!this.can_rotate)return;
			
			var g:uint;
			if(this.rot>i)
				g=(4-this.rot) +i;
			else
				g=i-this.rot;
			
			this.rot=i;
			
			check();
			var tTimer:Timer= new Timer(15, g*90);
			tTimer.addEventListener(TimerEvent.TIMER, onTimer);
			tTimer.addEventListener(TimerEvent.TIMER_COMPLETE, uncheck);
 			tTimer.start();
			
		}
        override protected function createChildren():void
        {
            super.createChildren();

            if(!this.view)
            {
                this.view = new View3D();

                this.view.camera.moveTo(0, 0, -1500);
                this.view.camera.lookAt(new Number3D(0, 0, 0));

            }
            try
            {
                this.getChildIndex(this.view);
            }
            catch (e:Error)
            {
                this.addChild(this.view);
            }

            if(!this.deskCube)
            {
            	this.deskCube = new Cube({name: "cube", width:FlexGlobals.topLevelApplication.width, height:FlexGlobals.topLevelApplication.height, 
                 depth:FlexGlobals.topLevelApplication.width,cubeMaterials: mat});

            }
            try
            {
                if(this.view.scene.getChildByName(this.deskCube.name) == null)
                    this.view.scene.addChild(this.deskCube);
            }
            catch (e:Error)
            {
                this.view.scene.addChild(this.deskCube);
            }
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            if(this.width / 2 != this.view.x)
                this.view.x = this.width / 2;
            if(this.height / 2 != this.view.y)
                this.view.y = this.height / 2;
        }

        private function onFrameEnter(event:flash.events.Event):void
        {
            if(this.view && this.view.stage)
            {
               
                this.view.render();
            }
        }
    
    }
}
