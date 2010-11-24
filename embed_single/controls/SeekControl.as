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

/*Unlike the VolControl class I don't want to update this
LIVE, so I only update when I'm done dragging.*/
package controls {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	public class SeekControl extends MovieClip {
		private var bounds:Rectangle;
		public var percent:Number;
		public var seeking:Boolean;
    public var seekBarWidth:int = 2548;
    public var handleY:int = 3;
		
		public function SeekControl() {
			seeking = false;
			percent = 0;
			bounds = new Rectangle(0, handleY, seekBarWidth, 0);
      loadBar_mc.width = 3000.3;
			loadBar_mc.x = - loadBar_mc.width;
			
			seekHit_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragHandle, false, 0, true);
// PMD
//			seekHit_mc.addEventListener(MouseEvent.MOUSE_UP, endDrag, false, 0, true);
			seekHandle_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragHandle, false, 0, true);
			seekHandle_mc.addEventListener(MouseEvent.MOUSE_UP, endDrag, false, 0, true);
		}
		
		private function dragHandle(event:MouseEvent):void {
			seeking = true;
			seekHandle_mc.startDrag(true, bounds);
		}
		private function endDrag(event:MouseEvent):void {
			seeking = false;
			seekHandle_mc.stopDrag();
			fillBar_mc.x = seekHandle_mc.x - fillBar_mc.width;
			percent = seekHandle_mc.x/seekBarWidth;
			dispatchEvent(new Event("seek_change"));
		}
		
		public function moveSeekPos(perc:Number):void {
			fillBar_mc.x = (fillBar_mc.width * perc) - fillBar_mc.width;
			if(!seeking)
			seekHandle_mc.x = seekBarWidth * perc;
		}

    public function moveLoadBar(perc:Number):void {
			loadBar_mc.x = (loadBar_mc.width * perc) - loadBar_mc.width;
    }

    public function changeBound(percentage):void{
      bounds = new Rectangle(0, handleY, seekBarWidth*percentage/100, 0);
    }
	}
}
