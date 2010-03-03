/******************************************************
*This code was origionally written by: Paul Schoneveld
*@ ClickPopMedia
*Paul doesn't rightly care what you do with this code,
*but he thinks it would be nice if you remembered him
*in your heart while using it.  Also, he would be happy
*if a link to http://www.clickpopmedia.com/ showed up
*on your site.  But, none of that is required nore could
*it be enforced.
*
*We at ClickPopMedia do not provide technical support for
*this code.  This code is provided for example and quick
*refrence only.  We will not stop you from using our code,
*but don't come to us if you can't get it to work.
********************************************************/
package {
	import flash.events.*;
	import flash.display.MovieClip;
  import flash.system.Security;
  import flash.external.*;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.net.*;
	
	public class Mp3Main extends MovieClip{
		public var position:Number;
    public var player:Player;
    public var song_id:String;
    public var passphrase:String;
    public var xmlLoaded:Boolean = false;

    public var wfAlreadyLoaded:Boolean = false;
    public var mcWF:MovieClip = new MovieClip();

    // Used in two ways
    public var autoplay:Boolean = false;

		/*The constructor mainly sets up the event listeners, but it also
		starts loading the XML playlist file.*/
		public function Mp3Main() {

      Security.allowDomain("cdn.gigya.com");
      Security.allowInsecureDomain("cdn.gigya.com");

			position = 0;

      player = new Player();
      player.addEventListener("playProgress",updateSeek);
      player.addEventListener("complete",onXMLLoad);
      player.addEventListener(ProgressEvent.PROGRESS,updateLoadBar);
      player.addEventListener(Event.SOUND_COMPLETE,onPlaybackComplete);

      title_mc.text = 'Loading ... please wait'
      currentTime_mc.text = '00:00'
      totalTime_mc.text = '00:00'

      commented_mc.autoSize = "center";
      liked_mc.autoSize = "center";
      fav_mc.autoSize = "center";
      downloadCount_mc.autoSize = "center";
      played_mc.autoSize = "center";

      var paramList:Object = this.root.loaderInfo.parameters;
      song_id = paramList.song_id ? paramList.song_id : '3220';
      passphrase = paramList.passphrase; 
      autoplay = paramList.autoplay ? true : false; 

      player.playMuzibooSong(song_id,autoplay,passphrase);

    
			vol_mc.addEventListener("volume_change", updateVolume, false, 0, true);
			seek_mc.addEventListener("seek_change", changeSeekBar, false, 0, true);
			seek_mc.moveSeekPos(0);
			
		/*****************Button Event Listeners************************/
			playPause_mc.addEventListener(MouseEvent.MOUSE_OVER, PlayOver);
			playPause_mc.addEventListener(MouseEvent.MOUSE_OUT, PlayOut);
			playPause_mc.addEventListener(MouseEvent.MOUSE_DOWN, PlayDown);
			playPause_mc.addEventListener(MouseEvent.MOUSE_UP, PlayUp);
			
			/*stop_mc.addEventListener(MouseEvent.MOUSE_OVER, StopOver);
			stop_mc.addEventListener(MouseEvent.MOUSE_OUT, StopOut);
			stop_mc.addEventListener(MouseEvent.MOUSE_DOWN, StopDown);
			stop_mc.addEventListener(MouseEvent.MOUSE_UP, StopUp);*/
			
			mute_mc.addEventListener(MouseEvent.MOUSE_OVER, MuteOver);
			mute_mc.addEventListener(MouseEvent.MOUSE_OUT, MuteOut);
			mute_mc.addEventListener(MouseEvent.MOUSE_DOWN, MuteDown);
			mute_mc.addEventListener(MouseEvent.MOUSE_UP, MuteUp);
			
			
      embed_mc.addEventListener(MouseEvent.CLICK, onEmbedClick);
      title_mc.addEventListener(MouseEvent.CLICK, onTitleClick);
      download_mc.addEventListener(MouseEvent.CLICK, onDownloadClick);

      // We wanna call embed function from outside
     	ExternalInterface.addCallback("embedPlayer",loadWildfire);  

			/*back_mc.addEventListener(MouseEvent.MOUSE_OVER, BackOver);
			back_mc.addEventListener(MouseEvent.MOUSE_OUT, BackOut);
			back_mc.addEventListener(MouseEvent.MOUSE_DOWN, BackDown);
			back_mc.addEventListener(MouseEvent.MOUSE_UP, BackUp);
			
			forward_mc.addEventListener(MouseEvent.MOUSE_OVER, ForwardOver);
			forward_mc.addEventListener(MouseEvent.MOUSE_OUT, ForwardOut);
			forward_mc.addEventListener(MouseEvent.MOUSE_DOWN, ForwardDown);
			forward_mc.addEventListener(MouseEvent.MOUSE_UP, ForwardUp);*/
		}
		
		/*This function is used to display the minutes and seconds of the current song.
		It is only used in the updateSeek() function.*/
		public function formatTime(time:Number):String {
			var min:String = Math.floor(time/60000).toString();
			var sec:String = (Math.floor((time/1000)%60) < 10)? "0" + Math.floor((time/1000)%60).toString() : Math.floor((time/1000)%60).toString();
			return(min+":"+sec);
		}
		
	/***********************Event Handlers****************************/
		/*I want to start loading the first song right after filling the
		List component.  If you want it to play automaticly, here is where
		you do that.*/

    private function onXMLLoad(event:Event){
      // TODO: Improve this code
      wait_mc.visible = false;
      title_mc.text = player.muzibooXMLParser.title ;
      commented_mc.text = player.muzibooXMLParser.comments_count;
      fav_mc.text = player.muzibooXMLParser.favorites_count;
      played_mc.text = player.muzibooXMLParser.play_count;

      downloadCount_mc.text = player.muzibooXMLParser.downloads_count;
//      downloadCount_icon_mc.x = commented_mc.x + commented_mc.width + 10;

      liked_mc.text = player.muzibooXMLParser.likes_count;
      bitrate_mc.text = player.muzibooXMLParser.bitrate ;
      if(!player.muzibooXMLParser.downloadable){
        download_mc.visible = false
      }
      this.xmlLoaded = true;
      if(this.autoplay){
        // Just to make sure
        playPause_mc.playing = true;
				playPause_mc.gotoAndStop('pause_over');
      }
    }
		
		private function updateVolume(event:Event):void {
      player.updateVolume(vol_mc.percent);
		}
		
    private function changeSeekBar(event:Event):void {
			position = (player.muzSong.length/(player.muzSong.bytesLoaded/player.muzSong.bytesTotal)) * seek_mc.percent;
			if(playPause_mc.playing){
        player.seekTo(position);
      }
    }

    private function onPlaybackComplete(event:Event):void {
      playPause_mc.playing = false;
      playPause_mc.gotoAndStop('play');
    }

    private function updateLoadBar(event:ProgressEvent):void {
      seek_mc.moveLoadBar(event.bytesLoaded/event.bytesTotal);
    }

		private function updateSeek(event:ProgressEvent):void {
      currentTime_mc.text = formatTime(event.bytesLoaded);
      totalTime_mc.text   = formatTime(event.bytesTotal);
      var perc:Number = event.bytesLoaded / event.bytesTotal; 
      if(player.loadedPct < 100){
        seek_mc.changeBound(player.loadedPct);
      }
			seek_mc.moveSeekPos(perc);
		}
		
	/*******************PlayPause Handlers*************************/
		private function PlayOver(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.playing) {
				obj.gotoAndStop('pause_over');
			} else {
				obj.gotoAndStop('play_over');
			}
		}
		private function PlayOut(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.playing) {
				obj.gotoAndStop('pause');
			} else {
				obj.gotoAndStop('play');
			}
		}
		private function PlayDown(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.playing) {
				obj.gotoAndStop('pause_down');
			} else {
				obj.gotoAndStop('play_down');
			}
		}
		/*Needs to switch between a pause and play button.*/
		private function PlayUp(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.playing) {
				obj.gotoAndStop('play_over');
        player.pauseSong();
				obj.playing = false;
			} else {
				obj.gotoAndStop('pause_over');
/*        if(this.xmlLoaded){
          player.loadMp3FileFromXML();
        }else{
          this.autoplay = true;
        } */
        // This time autoplay is true so whenever the xml is loaded, the song is played
        player.playMuzibooSong(song_id,true, passphrase);
				obj.playing = true;
			}
		}
		
	/********************Mute Handlers************************/
		private function MuteOver(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.isMute) {
				obj.gotoAndStop('unmute_over');
			} else {
				obj.gotoAndStop('mute_over');
			}
		}
		private function MuteOut(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.isMute) {
				obj.gotoAndStop('unmute');
			} else {
				obj.gotoAndStop('mute');
			}
		}
		private function MuteDown(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.isMute) {
				obj.gotoAndStop('unmute_down');
			} else {
				obj.gotoAndStop('mute_down');
			}
		}
		private function MuteUp(event:MouseEvent):void {
			var obj:Object = event.currentTarget;
			if(obj.isMute) {
				obj.gotoAndStop('mute_over');
				obj.isMute = false;
        player.unMute();
			} else {
				obj.gotoAndStop('unmute_over');
				obj.isMute = true;
        player.mute();
			}
		}

     private function onDownloadClick(evt:Event):void{
       var downloadUrl:String = player.muzibooXMLParser.downloadLink;
       var downloadRequest: URLRequest = new URLRequest(downloadUrl);
       navigateToURL(downloadRequest,"_blank");
     }

    public function onTitleClick(evt:Event):void {
       var songUrl:String = player.muzibooXMLParser.songLocation;
       var songRequest: URLRequest = new URLRequest(songUrl);
       navigateToURL(songRequest,"_blank");
    }
  
     public function onEmbedClick(evt:Event) : void{
        loadWildfire();
      }

     public function loadWildfire(){

            wait_mc.visible = true;
            //prevent creation of multiple instances of wildfire
            if (wfAlreadyLoaded) {
                mcWF.visible = true;               
                return;
            }
            else {
                wfAlreadyLoaded = true ;
            }

            //This code creates an empty movie clip to host the wildfire interface 
            addChild(mcWF).name='mcWF';

            //Please position Wildfire in your Flash
            mcWF.x=0;
            mcWF.y=0;

            // This code creates a configuration object through which Wildfire will communicate with the host swf
              var ModuleID:String='PostModule1';        // pass the module id to wildfire
              // Build configuration object
              var cfg:Object = { };     // initialize the configuration object

            //This code assigns the configurations you set in our site to the Wildfire configuration object
            cfg['width']='590';
            cfg['height']='80';
            cfg['advancedTracking']='true';
            cfg['useFacebookMystuff']='false';
            cfg['partner']='185391';
            cfg['UIConfig']='<config baseTheme="v2"><display showEmail="false" showBookmark="false" showCloseButton="true"></display><body><controls><snbuttons iconsOnly="true"></snbuttons></controls></body></config>';;

            // Please set up the content to be posted
            cfg['defaultContent']= player.muzibooXMLParser.embedText; // <-- YOUR EMBED CODE GOES HERE 

            var ldr:Loader = new Loader();

            // set up an event handler for the onClose event, this is called when the Wildfire UI is closed.
            cfg['onClose']=function(eventObj:Object):void{
                mcWF.visible = false;
                ldr.content['INIT']();
                //you can do additional cleanup here
                wait_mc.visible = false;
            }

            cfg['onLoad']=function(eventObj:Object):void{
              wait_mc.visible = false;
            }

            // This code calls up wildfire 
              var url:String = 'http://cdn.gigya.com/WildFire/swf/wildfireInAS3.swf?ModuleID=' + ModuleID;
              var urlReq:URLRequest = new URLRequest(url);
              mcWF[ModuleID] = cfg;
              ldr.load(urlReq);
              mcWF.addChild(ldr);
        }


          }
        }
