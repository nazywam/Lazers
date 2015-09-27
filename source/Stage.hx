import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class Stage extends FlxGroup {

	var background:FlxSprite;

	var stageNumber:Int;

	public var levelIcons:FlxTypedGroup<LevelIcon>;

	var y:Float;
	override public function new(_s:Int){
		super();

		stageNumber = _s;
		y = Settings.STAGE_HEIGHT * _s;

		background = new FlxSprite(0, y);
		background.loadGraphic(Settings.STAGES, true, FlxG.width, 180);
		background.animation.add("default", [stageNumber]);
		background.animation.play("default");
		add(background);

		levelIcons = new FlxTypedGroup<LevelIcon>();
		add(levelIcons);

		for(i in 0...Settings.LEVELS_IN_STAGE){
			var moveY = 0;
			if(i % 2 == 1){
				moveY = 60;
			}
			
			var l = new LevelIcon(16 + i*38, y + 64 + moveY, stageNumber+1, i+1);
			levelIcons.add(l);
		}
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		if(FlxG.mouse.justPressed){
			for(l in levelIcons){
				if(FlxG.mouse.overlaps(l.icon) && l.stage != 5){
					l.icon.scale.x = l.icon.scale.y = 2;
					FlxTween.tween(l.icon.scale, {x:1, y:1}, 1);
				}
			}
		}
	}
}