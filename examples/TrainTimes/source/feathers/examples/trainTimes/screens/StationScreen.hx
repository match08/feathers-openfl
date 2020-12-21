package feathers.examples.trainTimes.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.Screen;
import feathers.data.ListCollection;
import feathers.examples.trainTimes.model.StationData;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

class StationScreen extends Screen
{
	inline public static var CHILD_STYLE_NAME_STATION_LIST:String = "stationList";

	@:keep public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	public var selectedDepartureStation:StationData;
	public var selectedDestinationStation:StationData;

	private var _departureHeader:Header;
	private var _destinationHeader:Header;
	private var _backButton:Button;
	private var _stationList:List;

	private var _headerTween:Tween;

	override private function initialize():Void
	{
		this._stationList = new List();
		this._stationList.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST);
		this._stationList.dataProvider = new ListCollection(
		[
			new StationData("Ten Stone Road"),
			new StationData("Birch Grove"),
			new StationData("East Elm Court"),
			new StationData("Oakheart Hills"),
			new StationData("Timber Ridge"),
			new StationData("Old Mine Heights"),
			new StationData("Granite Estates"),
		]);
		this._stationList.itemRendererProperties.setProperty("confirmCallback", stationList_onConfirm);
		this._stationList.itemRendererProperties.setProperty("isInDestinationPhase", false);
		this.addChild(this._stationList);

		this._backButton = new Button();
		this._backButton.visible = false;
		this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		this._departureHeader = new Header();
		this._departureHeader.title = "Choose Departure Station";
		this.addChild(this._departureHeader);

		this._destinationHeader = new Header();
		this._destinationHeader.title = "Choose Destination Station";
		this._destinationHeader.leftItems = 
		[
			this._backButton
		];
		this.addChild(this._destinationHeader);
	}

	override private function draw():Void
	{
		this._departureHeader.width = this.actualWidth;
		this._destinationHeader.width = this.actualWidth;

		var currentHeader:Header;
		if(this.selectedDepartureStation != null)
		{
			currentHeader = this._destinationHeader;
			this._destinationHeader.x = 0;
			this._destinationHeader.visible = true;
			this._departureHeader.x = this.actualWidth;
			this._departureHeader.visible = false;
		}
		else
		{
			currentHeader = this._departureHeader;
			this._destinationHeader.x = -this.actualWidth;
			this._destinationHeader.visible = false;
			this._departureHeader.x = 0;
			this._departureHeader.visible = true;
		}

		currentHeader.validate();
		this._stationList.y = currentHeader.height;
		this._stationList.width = this.actualWidth;
		this._stationList.height = this.actualHeight - this._stationList.y;
	}

	private function onBackButton():Void
	{
		this.selectedDepartureStation.isDepartingFromHere = false;
		var index:Int = this._stationList.dataProvider.getItemIndex(this.selectedDepartureStation != null);
		this._stationList.dataProvider.updateItemAt(index);
		this._stationList.selectedItem = this.selectedDepartureStation;
		this.selectedDepartureStation = null;
		this._backButton.visible = false;
		this._departureHeader.title = "Choose Departure Station";
		this._stationList.itemRendererProperties.setProperty("isInDestinationPhase", false);

		this._departureHeader.visible = true;
		if(this._headerTween != null)
		{
			Starling.current.juggler.remove(this._headerTween);
			this._headerTween = null;
		}
		this._headerTween = new Tween(this._departureHeader, 0.4, Transitions.EASE_OUT);
		this._headerTween.animate("x", 0);
		this._headerTween.onUpdate = headerTween_onUpdate;
		this._headerTween.onComplete = headerTween_onDestinationHideComplete;
		Starling.current.juggler.add(this._headerTween);
	}

	private function stationList_onConfirm():Void
	{
		if(this.selectedDepartureStation != null)
		{
			this.selectedDestinationStation = cast(this._stationList.selectedItem, StationData);
			this.dispatchEventWith(Event.COMPLETE);
			return;
		}
		this.selectedDepartureStation = cast(this._stationList.selectedItem, StationData);
		this.selectedDepartureStation.isDepartingFromHere = true;

		this._departureHeader.title = "Choose Destination Station";
		this._backButton.visible = true;

		this._stationList.selectedIndex = -1;
		this._stationList.itemRendererProperties.setProperty("isInDestinationPhase", true);

		this._destinationHeader.visible = true;
		if(this._headerTween != null)
		{
			Starling.current.juggler.remove(this._headerTween);
			this._headerTween = null;
		}
		this._headerTween = new Tween(this._departureHeader, 0.4, Transitions.EASE_OUT);
		this._headerTween.animate("x", this.actualWidth);
		this._headerTween.onUpdate = headerTween_onUpdate;
		this._headerTween.onComplete = headerTween_onDestinationShowComplete;
		Starling.current.juggler.add(this._headerTween);
	}

	private function headerTween_onUpdate():Void
	{
		this._destinationHeader.x = this._departureHeader.x - this.actualWidth;
	}

	private function headerTween_onDestinationShowComplete():Void
	{
		this._departureHeader.visible = false;
		this._headerTween = null;
	}

	private function headerTween_onDestinationHideComplete():Void
	{
		this._destinationHeader.visible = false;
		this._headerTween = null;
	}

	private function addedToStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
	}

	private function removedFromStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		#if flash
		if(event.keyCode == Keyboard.BACK && this.selectedDepartureStation)
		{
			event.preventDefault();
			this.onBackButton();
		}
		#end
	}
}
