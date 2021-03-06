import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Stage extends FlxGroup {

	var background:FlxSprite;

	var stageNumber:Int;

	public var levelIcons:FlxTypedGroup<LevelIcon>;

	public var y:Float;
	
	override public function new(_s:Int, _y:Float){
		super();

		stageNumber = _s;
		y = _y + Settings.STAGE_HEIGHT * _s;

		background = new FlxSprite(0, y);
		background.loadGraphic(Settings.STAGES, true, 720, 360);
		background.animation.add("default", [stageNumber]);
		background.animation.play("default");
		add(background);
		
		levelIcons = new FlxTypedGroup<LevelIcon>();
		add(levelIcons);

		for(i in 0...Settings.LEVELS_IN_STAGE){
			var moveY = 0;
			if(i % 2 == 1){
				moveY = 120;
			}
			
			var l = new LevelIcon(32 + i*38*2, y + 128 + moveY, stageNumber, i, Settings.SAVES.data.completedLevels[i + stageNumber * Settings.LEVELS_IN_STAGE]);
			levelIcons.add(l);
		}
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		
		background.y = y;
		
		for (i in 0...levelIcons.members.length) {
			var moveY = 0;
			if(i % 2 == 1){
				moveY = 120;
			}
			
			levelIcons.members[i].y = y + 128 + moveY;
		}
	}
}