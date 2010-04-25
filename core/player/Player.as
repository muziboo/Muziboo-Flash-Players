package
{
	import flash.events.EventDispatcher;
	
	public class Player extends EventDispatcher
	{
		import flash.events.*; 
  		import flash.net.URLRequest;
  		import flash.net.URLLoader; 
  		import flash.media.Sound;
  		import flash.media.SoundChannel;
  		import flash.media.SoundTransform;
  		import flash.utils.Timer;
  			
			trace('Welcome to Muziboo AS Player');
			
			public var muzibooXMLParser:MuzibooXMLParser;
			public var isXMLLoaded:Boolean = false;

      // Already in the process of loading XML?
			public var isXMLLoading:Boolean = false;
			public var muzSong:Sound;
			public var isPlaying:Boolean = false;
			public var isPaused:Boolean = false;
			public var isMuted:Boolean = false;
			public var isMp3Loaded:Boolean = false;
			public var pausedPosition:int = 0;
			public var sChannel:SoundChannel;
			public var muzSongID:String;
			public var sndTrans:SoundTransform;
			public var playTimer:Timer;
			public var progressInterval:int = 1000;
			public static const PLAY_PROGRESS:String = "playProgress";
			public var autoplay:Boolean=false;
			public var loadedPct:uint = 0;					

   		public function updateVolume(currentVol:Number){
   			trace('Change vol to '+currentVol);
				this.sndTrans.volume = currentVol;
				this.sChannel.soundTransform = this.isMuted ? new SoundTransform(0): this.sndTrans;
      }
					
			private function onXMLLoad(event:Event):void{
				trace('loaded xml');
				if(this.autoplay){				
					trace('playing');
					this.loadMp3FileFromXML();
				}																		
				this.isXMLLoaded = true;
				this.isXMLLoading = false;
     		this.dispatchEvent(event.clone())
			}
			
			public function loadMp3FileFromXML():void{
				loadMp3File(this.muzibooXMLParser.mp3Location,this.muzibooXMLParser.id);
			}
			
			
			public function loadMp3File(mp3Location:String,songID:String):void{
				var muzSongReq:URLRequest = new URLRequest(mp3Location);
				this.muzSong = new Sound(muzSongReq);
				this.muzSong.addEventListener(Event.COMPLETE,onSongLoaded);
				this.muzSong.addEventListener(Event.OPEN, onLoadOpen);
				this.muzSong.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);		
        this.isMp3Loaded = true;
			}
			
			public function onPlayTimer(event:TimerEvent):void 
			{
    			var estimatedLength:int = Math.ceil(this.muzSong.length / (this.muzSong.bytesLoaded / this.muzSong.bytesTotal));
    			var progEvent:ProgressEvent = new ProgressEvent(PLAY_PROGRESS, false, false, this.sChannel.position, estimatedLength);
    			this.dispatchEvent(progEvent);
			}
			
			private function onLoadProgress(event:ProgressEvent):void{
				 loadedPct = Math.round(100 * (event.bytesLoaded / event.bytesTotal));	
				 this.dispatchEvent(event.clone());			 
			}
			
			public function unloadMp3File():void{
				try{
					// if the stream is still open, close it
					this.muzSong.close();
				}
				catch(e){
					// Do nothing .. stream is closed
					trace(e);
				}
				
				this.sChannel.stop();
				this.isXMLLoaded = false;
        this.isMp3Loaded = false;
			}

			
			public function playSong(position:int = 0):void{
        if(this.isMp3Loaded){
  				this.sChannel = this.muzSong.play(position);
	  			this.isPlaying = true;
		  		this.sChannel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
       	  this.playTimer.start();
          if(position==0){
  	        // Played from start. Callback for play count
         		this.muzStatsCallback();
            dispatchEvent(new Event("new_playback_started"));
          }
        }else{
          this.loadMp3FileFromXML();
        }
			}
			
			public function seekTo(position):void{
				this.sChannel.stop()
				this.playSong(position);	
				if(!this.isMuted){
					this.sChannel.soundTransform = this.sndTrans;
				}			
			}
			
			private function onPlaybackComplete(event:Event):void{
					// Playback Complete .. call the js function
          this.playTimer.stop();
    			var estimatedLength:int = Math.ceil(this.muzSong.length / (this.muzSong.bytesLoaded / this.muzSong.bytesTotal));
    			var progEvent:ProgressEvent = new ProgressEvent(PLAY_PROGRESS, false, false, 0, 10);
    			this.dispatchEvent(progEvent);
					this.dispatchEvent(event.clone());
//					ExternalInterface.call("Muziboo.Player.onComplete");
			}
			
			public function pauseSong():void{
				pausedPosition = sChannel.position;
				stopSong();
				this.isPaused = true; 
			}
			
			private function stopSong():void{
				this.isPlaying = false;
				sChannel.stop();
			}
			
			private function onLoadOpen(event:Event):void{
				playSong();
			}
			
			private function onSongLoaded(event:Event):void{

			}
			
			private function onIOError(event:Event):void{
				trace('Error in loading mp3');
			}
			
			private function muzStatsCallback():void{
				var muzibooCallbackURL:String = 'http://www.muziboo.com/song/played/'+this.muzSongID+'?state=start';
				var muzibooCallbackRequest:URLRequest = new URLRequest(muzibooCallbackURL);
				new URLLoader(muzibooCallbackRequest);
			}
			
			// Autoplay is true because we want button players to play as soon as XML is loaded
			public function playMuzibooSong(songID:String, autoPlay:Boolean=true, passphrase:String=null):void{
				this.autoplay = autoPlay;
        this.muzSongID = songID;
        		if(!this.isXMLLoaded){
              if(!this.isXMLLoading){
              		trace('Starting to load xml file');
          			this.muzibooXMLParser = new MuzibooXMLParser(songID,passphrase);
        			  this.muzibooXMLParser.addEventListener("complete", this.onXMLLoad);        			       
                this.isXMLLoading = true;
              }            
        		}else{
          			if(this.isPaused){
            			this.playSong(this.pausedPosition);
          			}else{
            			this.playSong();
          			}
        		}
			}
			
			public function mute(){
				this.sChannel.soundTransform = new SoundTransform(0);
				this.isMuted = true;
			}
			
			public function unMute(){
				this.sChannel.soundTransform = this.sndTrans;
				this.isMuted = false;
			}

		public function Player()
		{
			this.sndTrans = new SoundTransform(1);
      this.playTimer = new Timer(this.progressInterval);
      this.playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer);
		}
	}
}
