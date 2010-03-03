package {

	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.*;

	public class MuzibooASPlayer extends Sprite
	{
		private var player:Player = new Player();
		
		private function onPlaybackComplete(event:Event):void
		{
			trace('Completed AS Player play');
			ExternalInterface.call("Muziboo.Player.onComplete");			
		}
		
		public function MuzibooASPlayer()
		{
			trace('Welcome to Muziboo AS Player');
			player.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
        	ExternalInterface.addCallback("playMuzSong",player.playMuzibooSong);  
        	ExternalInterface.addCallback("pauseMuzSong",player.pauseSong);
        	ExternalInterface.addCallback("unloadMuzSong",player.unloadMp3File);  
		}
	}
}
