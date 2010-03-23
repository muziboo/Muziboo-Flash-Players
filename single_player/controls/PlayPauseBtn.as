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
package controls {
	import flash.display.MovieClip;
	
	public class PlayPauseBtn extends MovieClip {
		public var playing:Boolean;
		public var over_and_stopped:Boolean;
		
		public function PlayPauseBtn() {
			this.playing = false;
      this.over_and_stopped = false;
			this.mouseChildren = false;
			this.stop();
		}
	}
}
