// ActionScript file
package SO.Pipes{
	class ImageQuery extends Query
	{
		private var send_compressed:Boolean = false;    // send always uncompressed bytearrays (i.e. your server doesn not support "gzuncompress")
        private var encoder:JPGEncoder;
		
		
		public function ImageQuery()
		{
			
		}
		private function savejpeg_resultHandler(event:ResultEvent):void
            {
                if(event.result || event.result is String)
                {
                    var path:String = event.result as String;
                    trace(path);

                    var swf_loader:SWFLoader = preview_box.getChildByName("preview") as SWFLoader;
                    swf_loader.showBusyCursor = true;
                    swf_loader.load(path + "?rand=" + new Date().getTime());

                   
                }
            }

            /**
             * Default handler for the remote SaveAsByteArray function
             */
            private function savebyte(event:ResultEvent):BitmapData
            {
                var ba:ByteArray = event.result as ByteArray;
                try
                {
                    ba.uncompress();
                } catch(err:Error)
                {
                }

                var data:BitmapData = new BitmapData(original_image.width, original_image.height, false, 0);
                var bmp:Bitmap = new Bitmap(data);
                bmp.name = "image";
                data.setPixels(data.rect, ba);

                return data;
               
            }
            /**
             * Save the image using the JPEGEncoder class
             */
            private function saveJpegHandler(event:MouseEvent):void
            {
                             var swf_loader:SWFLoader = new SWFLoader();
                swf_loader.autoLoad = true;
                swf_loader.name = "preview";
                swf_loader.addEventListener(Event.COMPLETE, 
                		function(event:Event):void { image_size.text = 'Image size: ' + (SWFLoader(event.target).bytesTotal/1024).toPrecision(3) + ' Kb' });
                preview_box.addChildAt(swf_loader, 0);

                var bmpdata:BitmapData = Bitmap(original_image.content).bitmapData;
                var ba:ByteArray;

                encoder = new JPGEncoder(jpeg_quality.value);
                ba = encoder.encode( bmpdata );

                if(send_compressed)
                    ba.compress();

                service.getOperation("SaveAsJPEG").send(ba, send_compressed);


            }


            private function saveByte(bmpdata:BitmapData):void
            {
                var arr:ByteArray = Bitmap(original_image.content).bitmapData.getPixels(new Rectangle(0,0,bmpdata.width, bmpdata.height));

                if(send_compressed)
                    arr.compress();

                arr.position = 0;
                service.getOperation("SaveAsByteArray").send(arr, send_compressed);

       
            }

	}
}