package SO
{
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	
	import mx.graphics.ImageSnapshot;
	public class Util
	{
		public  function Util():void
		{
		}
          public static function takeSnapshot(source:IBitmapDrawable):ByteArray {
          		
                var imageSnap:ImageSnapshot = ImageSnapshot.captureImage(source);
                var imageByteArray:ByteArray = imageSnap.data as ByteArray;
                return imageByteArray;
            }
 		}
 
}