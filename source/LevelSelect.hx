import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
class LevelSelect extends FlxState {
	
	var levelIcons:FlxTypedGroup<LevelIcon>;
	var transitionScreen:TransitionScreen;

	var stages:Array<Stage>;

	var animation:FlxTypedGroup<FlxSprite>;

	override public function create(){
		super.create();
	
		stages = new Array<Stage>();

		for(i in 0...1){
			var s = new Stage(i);
			add(s);
			stages.push(s);
		}
/*
		stage1 = new FlxSprite(0, 0, Settings.STAGE_1);
		add(stage1);

		levelIcons = new FlxTypedGroup<LevelIcon>();
		add(levelIcons);
		
		for (y in 0...Settings.LEVEL_ROWS) {
			for (x in 0...Settings.LEVEL_COLUMNS) {
				var moveY = 0;
				if(x % 2 == 1){
					moveY = 32;
				}

				var l = new LevelIcon(x * 64 + (FlxG.width - Settings.LEVEL_COLUMNS * 64 + 16)/2, 24 + y * 64 + moveY, y*Settings.LEVEL_ROWS + x + 1);
				levelIcons.add(l);
			}
		}
		*/
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {			
			for (l in levelIcons) {
				if (FlxG.mouse.overlaps(l.icon)) {
					transitionScreen.running = false;
					transitionScreen.start();

					var t = new FlxTimer();
					t.start(.65, function(_) {
						FlxG.switchState(new PlayState(l.level));		
					});
				}
			}
		}	
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		//handleMouse();
	}
}