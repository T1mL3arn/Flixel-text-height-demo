package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// I cannot compile flash with `new FlxGame(0, 0, PlayState, true)`
		// "Cannot skip non-nullable argument updateFramerate"
		// Other targets (html5, hl) works though.
		// Haxe, please.
		var game = new FlxGame(0, 0, PlayState);
		@:privateAccess game._skipSplash = true;
		addChild(game);
	}
}
