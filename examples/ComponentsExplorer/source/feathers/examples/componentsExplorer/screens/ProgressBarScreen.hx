package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PanelScreen;
import feathers.controls.ProgressBar;
import feathers.skins.IStyleProvider;
import feathers.system.DeviceCapabilities;
import starling.utils.Max;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

@:keep class ProgressBarScreen extends PanelScreen
{
	public static var globalStyleProvider:IStyleProvider;

	public function new()
	{
		super();
	}

	private var _horizontalProgress:ProgressBar;
	private var _verticalProgress:ProgressBar;

	private var _horizontalProgressTween:Tween;
	private var _verticalProgressTween:Tween;

	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ProgressBarScreen.globalStyleProvider;
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Progress Bar";

		this._horizontalProgress = new ProgressBar();
		this._horizontalProgress.direction = ProgressBar.DIRECTION_HORIZONTAL;
		this._horizontalProgress.minimum = 0;
		this._horizontalProgress.maximum = 1;
		this._horizontalProgress.value = 0;
		this.addChild(this._horizontalProgress);

		this._verticalProgress = new ProgressBar();
		this._verticalProgress.direction = ProgressBar.DIRECTION_VERTICAL;
		this._verticalProgress.minimum = 0;
		this._verticalProgress.maximum = 100;
		this._verticalProgress.value = 0;
		this.addChild(this._verticalProgress);

		this.headerFactory = this.customHeaderFactory;

		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.backButtonHandler = this.onBackButton;
		}

		this._horizontalProgressTween = new Tween(this._horizontalProgress, 5);
		this._horizontalProgressTween.animate("value", 1);
		this._horizontalProgressTween.repeatCount = Max.INT_MAX_VALUE;
		Starling.current.juggler.add(this._horizontalProgressTween);

		this._verticalProgressTween = new Tween(this._verticalProgress, 8);
		this._verticalProgressTween.animate("value", 100);
		this._verticalProgressTween.repeatCount = Max.INT_MAX_VALUE;
		Starling.current.juggler.add(this._verticalProgressTween);
	}

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			var backButton:Button = new Button();
			backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			header.leftItems = 
			[
				backButton
			];
		}
		return header;
	}

	private function onBackButton():Void
	{
		if(this._horizontalProgressTween != null)
		{
			Starling.current.juggler.remove(this._horizontalProgressTween);
			this._horizontalProgressTween = null;
		}
		if(this._verticalProgressTween != null)
		{
			Starling.current.juggler.remove(this._verticalProgressTween);
			this._verticalProgressTween = null;
		}
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
}
