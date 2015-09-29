import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
class LevelSelect extends FlxState {
	
	var transitionScreen:TransitionScreen;

	var stages:FlxTypedGroup<Stage>;

	var scroll:Float = 0;
	var tmpScroll:Float = 0;
	
	var pressedPoint:FlxPoint;
	var pressedLevelIcon:LevelIcon;
	var scrolling:Bool = false;
	
	var logo:FlxSprite;
	var howToPlayTitle:Button;
	var howTos:FlxTypedGroup<FlxSprite>;
	var levelSelectTitle:Button;
	
	override public function create(){
		super.create();
		
		if (Settings.SAVES == null) {		
			Settings.SAVES = new FlxSave();
			Settings.SAVES.bind("1010011010");
		}
		
		if (Settings.SAVES.data.completedLevels == null) {
			Settings.SAVES.data.completedLevels = new Array<Bool>();
		}
				
		logo = new FlxSprite(FlxG.width/2, 32);
		logo.loadGraphic(Settings.FIRE_DEM_LAZERS, true, 240, 156);
		logo.x -= logo.width/2;
		logo.animation.add("default", [0,1,2,3,4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0,], 12);
		logo.animation.play("default");
		add(logo);
		
		howToPlayTitle = new Button(0, logo.y + logo.height + 32, "How To Play", FlxG.width, 36);
		add(howToPlayTitle);
		
		howTos = new FlxTypedGroup<FlxSprite>();
		add(howTos);
		for (x in 0...Settings.AVAILABLE_HOW_TOS) {
			var h = new FlxSprite(0, howToPlayTitle.y + howToPlayTitle.background.height + 180 * x);
			h.loadGraphic(Settings.HOW_TO_PLAY + Std.string(x) + ".png", true, 360, 180);
			h.animation.add("default", [for (i in 0...Settings.HOW_TO_ANIMATIONS[x]) i], 3);
			h.animation.play("default");
			howTos.add(h);
		}
		
		levelSelectTitle = new Button(0, howToPlayTitle.y + howToPlayTitle.background.height + 180 * Settings.AVAILABLE_HOW_TOS, "Select Level", FlxG.width, 36);
		add(levelSelectTitle);
		
		stages = new FlxTypedGroup<Stage>();
		add(stages);
		pressedPoint = new FlxPoint(-1, -1);
		
		
		for(i in 0...5){
			var s = new Stage(i, levelSelectTitle.y + levelSelectTitle.background.height);
			stages.add(s);
		}
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {			
			
			pressedPoint.set(FlxG.mouse.screenX, FlxG.mouse.screenY);
			tmpScroll = scroll;
			for(s in stages){
				for (l in s.levelIcons) {
					if (FlxG.mouse.overlaps(l.icon)) {
						pressedLevelIcon = l;
					}
				}
			}
		}
		
		if (FlxG.mouse.justReleased) {
			pressedPoint.set( -1, -1);
			
			if(pressedLevelIcon != null && FlxG.mouse.overlaps(pressedLevelIcon) && !scrolling){
				transitionScreen.running = false;
				transitionScreen.start();

				var _stage = pressedLevelIcon.stage;
				var _level = pressedLevelIcon.level;

				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new PlayState(_stage, _level, true));		
				});
			}
			pressedLevelIcon = null;
			scrolling = false;
		}
		
		if (pressedPoint.y != -1) {
			if (Math.abs(FlxG.mouse.screenY - pressedPoint.y) > 4 || scrolling) {
				scroll = tmpScroll + pressedPoint.y - FlxG.mouse.screenY;
				scrolling = true;
			}
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		handleMouse();
		if (scroll < 0) {
			scroll += ( -scroll) / 4;
		} else if (scroll + FlxG.height > 1600) {
			scroll += (1600 - FlxG.height - scroll) / 4;
		}
		FlxG.camera.scroll.y += (scroll - FlxG.camera.scroll.y)/3;
	}
}