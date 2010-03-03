package
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MuzibooXMLParser extends EventDispatcher
	{
		
		public var duration;
		public var id;
		public var title;
		public var favorites_count;
		public var comments_count;
		public var play_count;
		public var downloads_count;
		public var likes_count;
		public var mp3Location;
		public var bitrate;
		public var downloadable:Boolean = false;
		public var songLocation:String;
		public var downloadLink:String;
		public var embedText:String;
		public var songXML:XML = new XML();
		public var songXMLLoader:URLLoader;

		private function onXMLLoad(event:Event):void{
			songXML = XML(songXMLLoader.data);			
			
			// Extract all the relevant info
			this.title = songXML.song_info.title.text();
			this.favorites_count = songXML.song_info.favorites_count.text();
			this.comments_count = songXML.song_info.comments_count.text();
			this.likes_count = songXML.song_info.votes_count.text();
			this.play_count = songXML.song_info.play_count.text();
			this.downloads_count = songXML.song_info.downloads_count.text();
			this.bitrate = songXML.song_info.bitrate.text();
			//this.bitrate = SongXML..bitrate;
			//this.duration = SongXML..duration;
			if(songXML..location_128.length()){
				trace('Found hifi');
				this.mp3Location = songXML..location_128;
			}else{
				trace('Found lo-fi');
				this.mp3Location = songXML..location;	
			}
			if(songXML..download_link.length()){
				this.downloadable = true;
				this.downloadLink = songXML..download_link;
				trace('Download Link: '+this.downloadLink);				
			}
			this.embedText = songXML..embed_text;
			this.songLocation = songXML..link;
			// Re-raise the event 
			this.dispatchEvent(event.clone());																			
		}

		public function MuzibooXMLParser(song_id:String, passphrase:String=null)
		{
			var songXMLLoc:String = 'http://www.muziboo.com/song/show/'+song_id+'.xml'+ (passphrase ? '?p='+passphrase : '');
		  	var songXMLURL:URLRequest = new URLRequest(songXMLLoc);
	
	  		songXMLLoader = new URLLoader(songXMLURL);
		  	songXMLLoader.addEventListener("complete", this.onXMLLoad);
		  	
		  	// For now save the id right here 
		  	this.id = song_id;
		}
	}
}
