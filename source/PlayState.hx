package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import openfl.Lib;
import openfl.text.TextField;

typedef TextOptions =
{
	?text:String,
	?x:Float,
	?y:Float,
	?width:Float,
	?height:Float,
	?autosize:Bool,
	?wordwrap:Bool,
	?autoHeight:Bool,
	?size:Int,
}

class PlayState extends FlxState
{
	var openflGroup = new openfl.display.Sprite();
	var flixelGroup = new FlxGroup();

	override public function create()
	{
		super.create();

		add(flixelGroup);
		flixelGroup.visible = true;

		Lib.current.stage.addChild(openflGroup);
		openflGroup.visible = false;

		// Some hints and notes about text fields:
		//
		// NOTE if autoSize is set then openfl TextField does not react
		// on setting its height.

		// Demo info:
		//
		// OpenFl textfield building options are different from Flixel,
		// Flixel does the same in its setters, but for OpenFl
		// this should be done excplicitly.
		//
		// Press O to switch between Flixel and OpenFl
		// Press U for delayed update for Flixel (these updates accumulate!)

		// 1. default FlxText has auto width and auto height
		var y = 25;
		var margin = 15;
		createFlixelText({text: 'Default FlxText', width: 0.0, y: y});
		createOpenflText({
			text: 'Default FlxText',
			y: y,
			autosize: true,
			wordwrap: false
		});

		// 2. FlxText with fixed width
		var width = FlxG.width * 0.6;
		y += (30 + margin);
		createFlixelText({text: 'FlxText with fixed width', width: width, y: y});
		createOpenflText({
			text: 'FlxText with fixed width',
			width: width,
			y: y,
			autosize: true,
			wordwrap: true,
		});

		// 3. FlxText with fixed width still has auto height
		y += (30 + margin);
		createFlixelText({
			text: 'FlxText with fixed width and words to show auto height',
			width: width,
			y: y
		});
		createOpenflText({
			text: 'FlxText with fixed width and words to show auto height',
			width: width,
			y: y,
			autosize: true,
			wordwrap: true,
		});

		// 4. FlxText with both width and height fixed
		y += (60 + margin);
		var height = 100;
		createFlixelText({
			text: 'FlxText with both width and height fixed',
			width: width,
			height: height,
			y: y,
		});
		createOpenflText({
			text: 'FlxText with both width and height fixed',
			width: width,
			height: height,
			y: y,
			autosize: false,
			wordwrap: true,
		});

		// 5. Nonnsence FlxText with auto width and fixed height.
		// It works the same as fully autosize field.
		y += (height + margin + 5);
		height = 65;
		createFlixelText({
			text: 'FlxText with fixed height and free width bla bla',
			width: 0,
			height: height,
			y: y,
		});
		createOpenflText({
			text: 'FlxText with fixed height and free width bla bla',
			width: 0,
			height: height,
			y: y,
			autosize: true,
			wordwrap: false
		});

		y += (height + margin + 5);
	}

	function createFlixelText(opts:TextOptions)
	{
		/**
			The problem: 
				FlxText does not support fixed height

			Current implementation details:
			- FlxText does not even have prop to set fixed height
			- FlxText uses `textHeight` property to redraw itslef. 
				This prop reads the real height of the text instead of 
				the height of text field.

			Solution:
			- FlxText must have prop to set height, e.g. `fieldHeight`
			- Need to figure out all relevant combinations of width,
				height, autosize, to test inconsistencies with openfl
					Default FlxText with fixed width:
						- width is SET
						- word wrap is TRUE
						- autosize is FALSE
					Similar TextField is:
						- width is SET
						- height is SET (but actually got determined automatically)
						- word wrap is true
						- autosize is SET
		**/

		trace('------- Flixel -------');

		var flixelText = new FlxText(opts.x ?? 10.0, opts.y ?? 0.0, opts.width ?? 0.0);

		flixelText.size = opts.size ?? 16;
		flixelText.bold = false;
		flixelText.color = 0x111111;
		flixelText.textField.background = true;
		flixelText.textField.backgroundColor = 0xEEEEEE;
		flixelText.textField.backgroundColor = 0xFF6666;
		flixelText.alignment = LEFT;

		flixelText.text = opts.text ?? '';
		// trace(textfield.fieldWidth, textfield.fieldHeight);
		if (opts.width != null)
			flixelText.fieldWidth = opts.width;
		// tracing it before setting autosize fixes hashlink target
		// i.e. FlxText get desired size (free width and fixed height)
		// trace(flixelText.textField.width, flixelText.textField.height);
		if (opts.height != null)
			flixelText.fieldHeight = opts.height;
		if (opts.autosize != null)
			flixelText.autoSize = opts.autosize;
		if (opts.wordwrap != null)
			flixelText.wordWrap = opts.wordwrap;

		trace(flixelText.fieldWidth, flixelText.fieldHeight, 'field');
		trace(flixelText.textField.textWidth, flixelText.textField.textHeight, 'text');
		trace(flixelText.width, flixelText.height, 'hitbox');

		flixelGroup.add(flixelText);
	}

	function updateFlixelText(flixelText:FlxText)
	{
		haxe.Timer.delay(() ->
		{
			flixelText.text += '. Bizz Bazz!';

			haxe.Timer.delay(() ->
			{
				flixelText.text += '\nLorem ipsum!';
			}, 1500);
		}, 1500);
	}

	function createOpenflText(opts:TextOptions)
	{
		trace('+++++++ OpenfFl +++++++');
		var field = new TextField();
		// make it match to flixel defaults
		field.autoSize = LEFT;
		field.selectable = false;
		field.multiline = true;
		field.wordWrap = true;
		field.height = 10;
		// ---

		var format = field.defaultTextFormat;
		format.font = FlxAssets.FONT_DEFAULT;
		format.size = 16;
		field.embedFonts = true;
		// format.font = 'Arial';
		// format.size = 20;
		// field.embedFonts = false;
		format.bold = false;
		format.color = 0x111111;
		format.align = LEFT;
		field.defaultTextFormat = format;
		// field.border = true;
		// field.borderColor = 0xFF0000;

		field.height = 16;
		field.background = true;
		field.backgroundColor = 0xEEEEEE;

		field.x = opts.x ?? 10.0;
		field.y = opts.y ?? 10.0;
		field.text = opts.text ?? '';

		opts.width = opts.width ?? 0.0;
		field.width = opts.width;

		if (opts.height != null)
			field.height = opts.height;

		if (opts.autosize != null)
			field.autoSize = opts.autosize ? LEFT : NONE;

		if (opts.wordwrap != null)
			field.wordWrap = opts.wordwrap;

		trace(field.width, field.height, 'field');
		trace(field.textWidth, field.textHeight, 'text');
		openflGroup.addChild(field);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.O)
		{
			openflGroup.visible = !openflGroup.visible;
			flixelGroup.visible = !flixelGroup.visible;
		}

		if (FlxG.keys.justPressed.U)
		{
			for (text in flixelGroup.members)
			{
				updateFlixelText(cast text);
			}
		}
		super.update(elapsed);
	}
}
