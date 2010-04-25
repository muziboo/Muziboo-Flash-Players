package {

	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.*;
	import flash.display.Loader;

	public class FBPlayer extends Sprite
	{
		private var player:Player = new Player();
		private var paramList:Object; 
		private var bridge:FbjsBridge; 
		private function onPlaybackComplete(event:Event):void
		{
			trace('Completed AS Player play');
			bridge.call("Muziboo.Player.onComplete");			
		}
		
		public function FBPlayer()
		{
			paramList = this.root.loaderInfo.parameters;
			bridge = new FbjsBridge(paramList);
			trace('Welcome to Muziboo AS Player');
			player.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
        	bridge.addCallback("playMuzSong",player.playMuzibooSong);  
        	bridge.addCallback("pauseMuzSong",player.pauseSong);
        	bridge.addCallback("unloadMuzSong",player.unloadMp3File);
        	bridge.connect();  
		}
	}
}