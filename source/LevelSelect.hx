import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
class LevelSelect extends FlxState {
	
	var transitionScreen:TransitionScreen;

	var stages:FlxTypedGroup<Stage>;

	var scroll:Float = 0;
	var tmpScroll:Float = 0;
	
	var pressedPoint:FlxPoint;
	var pressedLevelIcon:LevelIcon;
	var pressedButton:Button;
	
	var scrolling:Bool = false;
	
	var logo:FlxSprite;
	var howToPlayTitle:Button;
	var howTos:FlxTypedGroup<FlxSprite>;
	var levelSelectTitle:Button;
	var credits:Button;
	
	var maxScrollY : Float;
	
	var howToVisible : Bool = true;
	var toggleRunning : Bool = false;
	override public function create(){
		super.create();

		FlxG.switchState(new PlayState(5, 6, false));

		
		if (Settings.SAVES == null) {		
			Settings.SAVES = new FlxSave();
			Settings.SAVES.bind("1010011010");
		}
		
		if (Settings.SAVES.data.completedLevels == null) {
			Settings.SAVES.data.completedLevels = new Array<Bool>();
			for(i in 0...Settings.LEVELS_IN_STAGE * 4){
				Settings.SAVES.data.completedLevels.push(false);
			}
		} else {
			howToVisible = false;
		}
				
		scroll = Settings.SAVED_SCROLL;
		FlxG.camera.scroll.y = scroll;
		
		logo = new FlxSprite(0, 32);
		logo.loadGraphic(Settings.FIRE_DEM_LAZERS, true, 360, 60);
		logo.animation.add("default", [1,2,2, 3 ,3,4, 4, 4, 4, 4, 4, 4, 3,3 , 2, 2, 1, 1, 1, 1, 1, 1], 12);
		logo.animation.play("default");
		
		howToPlayTitle = new Button(0, logo.y + logo.height + 16, "How To Play", FlxG.width, 42);
		
		howTos = new FlxTypedGroup<FlxSprite>();
		for (x in 0...Settings.AVAILABLE_HOW_TOS) {
			
			var posY = howToPlayTitle.y + howToPlayTitle.background.height + 180 * x - 10;
			if (!howToVisible) {
				posY = -180 * (Settings.AVAILABLE_HOW_TOS - x) - 10 + howToPlayTitle.y + howToPlayTitle.background.height;
			}
			var h = new FlxSprite(0, posY);
			h.loadGraphic(Settings.HOW_TO_PLAY + Std.string(x) + ".png", true, 360, 180);
			h.animation.add("default", [for (i in 0...Settings.HOW_TO_ANIMATIONS[x]) i], 3);
			h.animation.play("default");
			howTos.add(h);
		}

		levelSelectTitle = new Button(0, howToPlayTitle.y + howToPlayTitle.background.height + 180 * Settings.AVAILABLE_HOW_TOS, "Select Level", FlxG.width, 42);
		
		stages = new FlxTypedGroup<Stage>();
		pressedPoint = new FlxPoint(-1, -1);
														

		for (i in 0...Settings.AVAILABLE_STAGES) {
			var s = new Stage(i, levelSelectTitle.y + levelSelectTitle.background.height);
			stages.add(s);
		}


		credits = new Button(0, levelSelectTitle.y + levelSelectTitle.background.height + Settings.STAGE_HEIGHT * Settings.AVAILABLE_STAGES + 16, "By: Nazywam : )", FlxG.width, 36);
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		
		maxScrollY = levelSelectTitle.y + levelSelectTitle.background.height + Settings.STAGE_HEIGHT * Settings.AVAILABLE_STAGES;
		
		var background = new FlxSprite(0, -FlxG.height - 48, Settings.BACKGROUND);
		
		add(howTos);
		add(stages);
		add(background);
		add(credits);
		add(howToPlayTitle);
		add(levelSelectTitle);
		add(logo);
		add(transitionScreen);
		
		if (!howToVisible) {
			howToVisible = true;
			toggleHowTo();
		}

	}
	
	function toggleHowTo() {
		if (!toggleRunning) {
			toggleRunning = true;
			howToVisible = !howToVisible;
			
			for (i in 0...howTos.members.length) {		
				var h = howTos.members[i];
				
				if (howToVisible) {
					FlxTween.tween(h, { y:howToPlayTitle.y + howToPlayTitle.background.height + 180 * i - 10}, 1, {ease:FlxEase.cubeInOut});
				} else {
					FlxTween.tween(h, { y:-180*(howTos.members.length - i) - 10 + howToPlayTitle.y + howToPlayTitle.background.height }, 1, {ease:FlxEase.cubeInOut});
				}
			}
			
			var t = new FlxTimer();
			t.start(1, function(_) { toggleRunning = false; } );
		}
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
			
			if (FlxG.mouse.overlaps(howToPlayTitle)) {
				pressedButton = howToPlayTitle;
			}
		}
		
		if (FlxG.mouse.justReleased) {
			pressedPoint.set( -1, -1);
			
			if (pressedButton == howToPlayTitle && FlxG.mouse.overlaps(howToPlayTitle) && !scrolling) {
				toggleHowTo();
			}
			
			if(pressedLevelIcon != null && FlxG.mouse.overlaps(pressedLevelIcon) && !scrolling){
				transitionScreen.running = false;
				transitionScreen.start();

				var _stage = pressedLevelIcon.stage;
				var _level = pressedLevelIcon.level;

				var t = new FlxTimer();
				t.start(.65, function(_) {
					Settings.SAVED_SCROLL = scroll;
					FlxG.switchState(new PlayState(_stage, _level, true));		
				});
			}
			pressedLevelIcon = null;
			pressedButton = null;
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
		} else if (scroll + FlxG.height > maxScrollY) {
			scroll += (maxScrollY - FlxG.height - scroll) / 4;
		}
		FlxG.camera.scroll.y += (scroll - FlxG.camera.scroll.y) / 3;
		
		
		levelSelectTitle.y = howTos.members[howTos.members.length - 1].y + 180 + 24;
		maxScrollY = levelSelectTitle.y + levelSelectTitle.background.height + Settings.STAGE_HEIGHT * Settings.AVAILABLE_STAGES;
		
		for (s in 0...stages.members.length) {
			stages.members[s].y = levelSelectTitle.y + levelSelectTitle.background.height + Settings.STAGE_HEIGHT * s;
		}
		credits.y = stages.members[stages.members.length-1].y +Settings.STAGE_HEIGHT + 32;
	}
}