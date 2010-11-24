/******************************************************
*This code was origionally written by: Paul Schoneveld
*@ ClickPopMedia
*Paul doesn't rightly care what you do with this code,
*but he thinks it would be nice if you remembered him
*in your heart while using it.  Also, he would be happy
*if a link to http://www.clickpopmedia.com/ showed up
*on your site.  But, none of that is required nore could
*it be enforced.
********************************************************/

/*Taking advantage of the drag function thise all becomes rather easy.
I want it to update the volume LIVE though so I need to dispatch events
regularly while dragging.*/
package controls {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	public class VolControl extends MovieClip {
		private var bounds:Rectangle;
		public var percent:Number;
		
		public function VolControl() {
			percent = 1;
			bounds = new Rectangle(0, 10, 50, 0);
			
			volBar_mc.hit_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragHandle, false, 0, true);
			volHandle_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragHandle, false, 0, true);
			volHandle_mc.addEventListener(MouseEvent.MOUSE_UP, endDrag, false, 0, true);
			volHandle_mc.addEventListener(MouseEvent.MOUSE_OUT, endDrag, false, 0, true);
		}
		
		private function dragHandle(event:MouseEvent):void {
			volHandle_mc.startDrag(true, bounds);
			this.addEventListener(Event.ENTER_FRAME, changeVol, false, 0, true);
		}
		private function endDrag(event:MouseEvent):void {
			volHandle_mc.stopDrag();
			volBar_mc.fullness_mc.fill_mc.x = volHandle_mc.x - volBar_mc.fullness_mc.fill_mc.width;
			percent = volHandle_mc.x/50;
			dispatchEvent(new Event("volume_change"));
			this.removeEventListener(Event.ENTER_FRAME, changeVol);
		}
		private function changeVol(event:Event):void {
			volBar_mc.fullness_mc.fill_mc.x = volHandle_mc.x - volBar_mc.fullness_mc.fill_mc.width;
			percent = volHandle_mc.x/50;
			dispatchEvent(new Event("volume_change"));
		}
	}
}