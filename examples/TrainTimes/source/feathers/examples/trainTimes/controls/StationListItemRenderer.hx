package feathers.examples.trainTimes.controls;
import feathers.controls.Button;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.examples.trainTimes.model.StationData;
import feathers.skins.IStyleProvider;

import openfl.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

class StationListItemRenderer extends FeathersControl implements IListItemRenderer
{
	inline public static var CHILD_STYLE_NAME_STATION_LIST_NAME_LABEL:String = "stationListNameLabel";
	inline public static var CHILD_STYLE_NAME_STATION_LIST_DETAILS_LABEL:String = "stationListDetailsLabel";
	inline public static var CHILD_STYLE_NAME_STATION_LIST_ACTION_CONTAINER:String = "stationListActionContainer";
	inline public static var CHILD_STYLE_NAME_STATION_LIST_CONFIRM_BUTTON:String = "stationListConfirmButton";
	inline public static var CHILD_STYLE_NAME_STATION_LIST_CANCEL_BUTTON:String = "stationListCancelButton";

	private static var HELPER_POINT:Point = new Point();
	private static var HELPER_TOUCHES_VECTOR:Array<Touch> = new Array();

	inline private static var DEPART_FROM_TEXT:String = "DEPART FROM";
	inline private static var DEPARTING_FROM_TEXT:String = "DEPARTING FROM";
	inline private static var TRAVEL_TO_TEXT:String = "TRAVEL TO";
	inline private static var QUESTION_MARK:String = "?";

	public static var globalStyleProvider:IStyleProvider;

	private static function defaultLoaderFactory():ImageLoader
	{
		return new ImageLoader();
	}

	@:keep public function new()
	{
		super();
		this.addEventListener(TouchEvent.TOUCH, touchHandler);
	}

	override private function get_defaultStyleProvider():IStyleProvider
	{
		return StationListItemRenderer.globalStyleProvider;
	}

	private var background:Quad;
	private var actionContainer:ScrollContainer;
	private var confirmButton:Button;
	private var cancelButton:Button;
	private var nameLabel:Label;
	private var detailsLabel:Label;
	private var icon:ImageLoader;

	private var _touchPointID:Int = -1;

	private var _data:StationData;

	public var data(get, set):Dynamic;
	public function get_data():Dynamic
	{
		return this._data;
	}

	public function set_data(value:Dynamic):Dynamic
	{
		if(this._data == value)
		{
			return get_data();
		}
		this._data = Std.is(value, StationData) ? cast(value, StationData) : null;
		this.isSelectionWaitingToBeAnimated = false;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_data();
	}

	private var _index:Int = -1;

	public var index(get, set):Int;
	public function get_index():Int
	{
		return this._index;
	}

	public function set_index(value:Int):Int
	{
		this._index = value;
		if(this._owner != null && this._owner.dataProvider != null)
		{
			this.isLastItem = this._index == this._owner.dataProvider.length - 1;
		}
		this.isFirstItem = this._index == 0;
		return get_index();
	}

	private var _isFirstItem:Bool = false;

	public var isFirstItem(get, set):Bool;
	public function get_isFirstItem():Bool
	{
		return this._isFirstItem;
	}

	public function set_isFirstItem(value:Bool):Bool
	{
		if(this._isFirstItem == value)
		{
			return get_isFirstItem();
		}
		this._isFirstItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isFirstItem();
	}

	private var _isLastItem:Bool = false;

	public var isLastItem(get, set):Bool;
	public function get_isLastItem():Bool
	{
		return this._isLastItem;
	}

	public function set_isLastItem(value:Bool):Bool
	{
		if(this._isLastItem == value)
		{
			return get_isLastItem();
		}
		this._isLastItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isLastItem();
	}

	private var _isInDestinationPhase:Bool = false;

	public var isInDestinationPhase(get, set):Bool;
	public function get_isInDestinationPhase():Bool
	{
		return this._isInDestinationPhase;
	}

	public function set_isInDestinationPhase(value:Bool):Bool
	{
		if(this._isInDestinationPhase == value)
		{
			return get_isInDestinationPhase();
		}
		this._isInDestinationPhase = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isInDestinationPhase();
	}

	private var _owner:List;

	public var owner(get, set):List;
	public function get_owner():List
	{
		return this._owner;
	}

	public function set_owner(value:List):List
	{
		if(this._owner == value)
		{
			return get_owner();
		}
		if(this._owner != null)
		{
			this._owner.removeEventListener(Event.SCROLL, owner_scrollHandler);
		}
		this._owner = value;
		if(this._owner != null)
		{
			this._owner.addEventListener(Event.SCROLL, owner_scrollHandler);
		}
		if(this._owner != null && this._owner.dataProvider != null)
		{
			this.isLastItem = this._index == this._owner.dataProvider.length - 1;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_owner();
	}

	private var isSelectionWaitingToBeAnimated:Bool = false;

	private var _isSelected:Bool = false;

	public var isSelected(get, set):Bool;
	public function get_isSelected():Bool
	{
		return this._isSelected;
	}

	public function set_isSelected(value:Bool):Bool
	{
		if(this._isSelected == value)
		{
			return get_isSelected();
		}
		this._isSelected = value;
		if(this.selectionTween != null)
		{
			Starling.current.juggler.remove(this.selectionTween);
			this.selectionTween = null;
		}
		this.isSelectionWaitingToBeAnimated = !this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA) && !this._data.isDepartingFromHere;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		this.dispatchEventWith(Event.CHANGE);
		return get_isSelected();
	}

	private var _normalIconTexture:Texture;

	public var normalIconTexture(get, set):Texture;
	public function get_normalIconTexture():Texture
	{
		return this._normalIconTexture;
	}

	public function set_normalIconTexture(value:Texture):Texture
	{
		if(this._normalIconTexture == value)
		{
			return get_normalIconTexture();
		}
		this._normalIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_normalIconTexture();
	}

	private var _firstNormalIconTexture:Texture;

	public var firstNormalIconTexture(get, set):Texture;
	public function get_firstNormalIconTexture():Texture
	{
		return this._firstNormalIconTexture;
	}

	public function set_firstNormalIconTexture(value:Texture):Texture
	{
		if(this._firstNormalIconTexture == value)
		{
			return get_firstNormalIconTexture();
		}
		this._firstNormalIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_firstNormalIconTexture();
	}

	private var _lastNormalIconTexture:Texture;

	public var lastNormalIconTexture(get, set):Texture;
	public function get_lastNormalIconTexture():Texture
	{
		return this._lastNormalIconTexture;
	}

	public function set_lastNormalIconTexture(value:Texture):Texture
	{
		if(this._lastNormalIconTexture == value)
		{
			return get_lastNormalIconTexture();
		}
		this._lastNormalIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_lastNormalIconTexture();
	}

	private var _selectedIconTexture:Texture;

	public var selectedIconTexture(get, set):Texture;
	public function get_selectedIconTexture():Texture
	{
		return this._selectedIconTexture;
	}

	public function set_selectedIconTexture(value:Texture):Texture
	{
		if(this._selectedIconTexture == value)
		{
			return get_selectedIconTexture();
		}
		this._selectedIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_selectedIconTexture();
	}

	private var _firstSelectedIconTexture:Texture;

	public var firstSelectedIconTexture(get, set):Texture;
	public function get_firstSelectedIconTexture():Texture
	{
		return this._firstSelectedIconTexture;
	}

	public function set_firstSelectedIconTexture(value:Texture):Texture
	{
		if(this._firstSelectedIconTexture == value)
		{
			return get_firstSelectedIconTexture();
		}
		this._firstSelectedIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_firstSelectedIconTexture();
	}

	private var _lastSelectedIconTexture:Texture;

	public var lastSelectedIconTexture(get, set):Texture;
	public function get_lastSelectedIconTexture():Texture
	{
		return this._lastSelectedIconTexture;
	}

	public function set_lastSelectedIconTexture(value:Texture):Texture
	{
		if(this._lastSelectedIconTexture == value)
		{
			return get_lastSelectedIconTexture();
		}
		this._lastSelectedIconTexture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_lastSelectedIconTexture();
	}

	private var _iconLoaderFactory:Void->ImageLoader = defaultLoaderFactory;

	public var iconLoaderFactory(get, set):Void->ImageLoader;
	public function get_iconLoaderFactory():Void->ImageLoader
	{
		return this._iconLoaderFactory;
	}

	public function set_iconLoaderFactory(value:Void->ImageLoader):Void->ImageLoader
	{
		if(this._iconLoaderFactory == value)
		{
			return get_iconLoaderFactory();
		}
		this._iconLoaderFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_iconLoaderFactory();
	}

	private var _paddingTop:Float = 0;

	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	private var _paddingRight:Float = 0;

	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	private var _paddingBottom:Float = 0;

	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	private var _paddingLeft:Float = 0;

	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	private var _gap:Float = 0;

	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}

	public function set_gap(value:Float):Float
	{
		if(this._gap == value)
		{
			return get_gap();
		}
		this._gap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_gap();
	}

	public var confirmCallback:Dynamic;

	private var selectionTween:Tween;

	override private function initialize():Void
	{
		this.background = new Quad(10, 10, 0x3b2a41);
		this.background.alpha = 0;
		this.addChild(this.background);

		this.detailsLabel = new Label();
		this.detailsLabel.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST_DETAILS_LABEL);
		this.addChild(this.detailsLabel);

		this.nameLabel = new Label();
		this.nameLabel.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST_NAME_LABEL);
		this.addChild(this.nameLabel);

		this.actionContainer = new ScrollContainer();
		this.actionContainer.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST_ACTION_CONTAINER);
		this.actionContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
		this.actionContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
		this.actionContainer.visible = false;
		this.addChild(this.actionContainer);

		this.confirmButton = new Button();
		this.confirmButton.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST_CONFIRM_BUTTON);
		this.confirmButton.addEventListener(Event.TRIGGERED, confirmButton_triggeredHandler);
		this.actionContainer.addChild(this.confirmButton);

		this.cancelButton = new Button();
		this.cancelButton.styleNameList.add(CHILD_STYLE_NAME_STATION_LIST_CANCEL_BUTTON);
		this.cancelButton.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
		this.actionContainer.addChild(this.cancelButton);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var selectionInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SELECTED);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		if(stylesInvalid)
		{
			this.refreshIcon();
		}

		if(dataInvalid || selectionInvalid || stylesInvalid)
		{
			this.commitData();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(dataInvalid || sizeInvalid || selectionInvalid)
		{
			this.layout();
		}
	}

	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = Math.isNaN(this.explicitWidth);
		var needsHeight:Bool = Math.isNaN(this.explicitHeight);
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		this.icon.validate();
		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			newWidth = this.icon.width;
			newWidth += this._paddingLeft + this._paddingRight;
		}
		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			newHeight = this.icon.height;
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	private function refreshIcon():Void
	{
		if(this.icon != null)
		{
			this.icon.removeFromParent(true);
		}

		this.icon = this._iconLoaderFactory();
		this.addChild(this.icon);
	}

	private function commitData():Void
	{
		if(this._owner != null)
		{
			var nameLabelText:String = this._data.name;
			if(this._isSelected)
			{
				nameLabelText += QUESTION_MARK;
			}
			this.nameLabel.text = nameLabelText;

			var displayAsSelected:Bool = this._isSelected || this._data.isDepartingFromHere;
			if(this.isFirstItem)
			{
				this.icon.source = displayAsSelected ? this._firstSelectedIconTexture : this._firstNormalIconTexture;
			}
			else if(this.isLastItem)
			{
				this.icon.source = displayAsSelected ? this._lastSelectedIconTexture : this._lastNormalIconTexture;
			}
			else
			{
				this.icon.source = displayAsSelected ? this._selectedIconTexture : this._normalIconTexture;
			}

			if(this._data.isDepartingFromHere)
			{
				this.detailsLabel.text = DEPARTING_FROM_TEXT;
			}
			else if(this._isInDestinationPhase)
			{
				this.detailsLabel.text = TRAVEL_TO_TEXT;
			}
			else
			{
				this.detailsLabel.text = DEPART_FROM_TEXT;
			}

			if(!this.isSelectionWaitingToBeAnimated)
			{
				this.background.alpha = displayAsSelected ? 1 : 0;
			}
			if(!this.isSelectionWaitingToBeAnimated || displayAsSelected)
			{
				this.detailsLabel.visible = displayAsSelected;
			}
			//the action container will disappear after the departure
			//station has been selected, so it has different rules
			if(!this._data.isDepartingFromHere && (!this.isSelectionWaitingToBeAnimated || this._isSelected))
			{
				this.actionContainer.visible = this._isSelected;
				this.actionContainer.alpha = this._isSelected ? 1 : 0;
			}
		}
		else
		{
			this.nameLabel.text = null;
			this.detailsLabel.text = null;
			this.actionContainer.visible = false;
			this.background.alpha = 0;
			this.icon.source = null;
		}
	}

	private function layout():Void
	{
		this.background.width = this.actualWidth;
		this.background.height = this.actualHeight;

		this.icon.validate();
		this.icon.x = this._paddingLeft;
		var leftMarginWidth:Float = this._paddingLeft + this.icon.width + this._gap;
		var availableLabelWidth:Float = this.actualWidth - this._paddingRight - leftMarginWidth;
		var availableLabelHeight:Float = this.actualHeight - this._paddingTop - this._paddingBottom;

		this.actionContainer.width = availableLabelWidth;

		this.nameLabel.validate();
		this.detailsLabel.validate();
		this.actionContainer.validate();

		var displayAsSelected:Bool = this._isSelected || this._data.isDepartingFromHere;
		if((displayAsSelected && this.isSelectionWaitingToBeAnimated) ||
			(!displayAsSelected && !this.isSelectionWaitingToBeAnimated))
		{
			this.actionContainer.x = this.actualWidth;
			this.detailsLabel.alpha = 0;
			this.nameLabel.x = leftMarginWidth;
		}
		else
		{
			this.actionContainer.x = this.actualWidth - this.actionContainer.width;
			this.detailsLabel.alpha = 1;
			this.nameLabel.x = leftMarginWidth + (availableLabelWidth - this.nameLabel.width) / 2;
		}
		if(this.isSelectionWaitingToBeAnimated)
		{
			this.isSelectionWaitingToBeAnimated = false;
			this.selectionTween = new Tween(this.nameLabel, 0.35, Transitions.EASE_OUT);
			if(displayAsSelected)
			{
				this.selectionTween.animate("x", leftMarginWidth + (availableLabelWidth - this.nameLabel.width) / 2);
				this.selectionTween.onComplete = selectionTween_onSelectComplete;
			}
			else
			{
				this.selectionTween.animate("x", leftMarginWidth);
				this.selectionTween.onComplete = selectionTween_onDeselectComplete;
			}
			this.selectionTween.onUpdate = selectionTween_onUpdate;
			Starling.current.juggler.add(this.selectionTween);
		}
		else if(this._data.isDepartingFromHere && this.actionContainer.visible)
		{
			this.selectionTween = new Tween(this.actionContainer, 0.35, Transitions.EASE_OUT);
			this.selectionTween.fadeTo(0);
			this.selectionTween.onComplete = selectionTween_onConfirmComplete;
			Starling.current.juggler.add(this.selectionTween);
		}

		this.nameLabel.y = (availableLabelHeight - this.nameLabel.height) / 2;
		this.detailsLabel.x = leftMarginWidth + (availableLabelWidth - this.detailsLabel.width) / 2;
		this.detailsLabel.y = this.nameLabel.y - this.detailsLabel.height + this.detailsLabel.height - this.detailsLabel.baseline;
		this.actionContainer.y = this.actualHeight - this.actionContainer.height;
	}

	private function selectionTween_onUpdate():Void
	{
		var ratio:Float = this.selectionTween.transitionFunc(this.selectionTween.currentTime / this.selectionTween.totalTime);
		if(!this._isSelected)
		{
			ratio = 1 - ratio;
		}
		this.detailsLabel.alpha = this.background.alpha = ratio;
		this.actionContainer.x = this.actualWidth - this.actionContainer.width * ratio;
	}

	private function selectionTween_onSelectComplete():Void
	{
		this.selectionTween = null;
	}

	private function selectionTween_onDeselectComplete():Void
	{
		this.detailsLabel.visible = false;
		this.actionContainer.visible = false;
		this.selectionTween = null;
	}

	private function selectionTween_onConfirmComplete():Void
	{
		this.actionContainer.visible = false;
		this.selectionTween = null;
	}

	private function selectionTween_onUnconfirmComplete():Void
	{
		this.selectionTween = null;
	}

	private function touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			return;
		}

		var touches:Array<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
		if(touches.length == 0)
		{
			//end of hover
			return;
		}
		if(this._touchPointID >= 0)
		{
			var touch:Touch = null;
			for (currentTouch in touches)
			{
				if(currentTouch.id == this._touchPointID)
				{
					touch = currentTouch;
					break;
				}
			}

			if(touch == null)
			{
				//end of hover
				HELPER_TOUCHES_VECTOR.splice(0, HELPER_TOUCHES_VECTOR.length);
				return;
			}

			if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				touch.getLocation(this, HELPER_POINT);
				var isInBounds:Bool = this.hitTest(HELPER_POINT, true) != null;
				if(isInBounds)
				{
					if(!this._isSelected && !this._data.isDepartingFromHere)
					{
						this.isSelected = true;
					}
				}
			}
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			for (touch in touches)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					this._touchPointID = touch.id;
					break;
				}
			}
		}
		HELPER_TOUCHES_VECTOR.splice(0, HELPER_TOUCHES_VECTOR.length);
	}

	private function owner_scrollHandler(event:Event):Void
	{
		this._touchPointID = -1;
	}

	private function confirmButton_triggeredHandler(event:Event):Void
	{
		if(this.confirmCallback == null)
		{
			return;
		}
		this.confirmCallback();
	}

	private function cancelButton_triggeredHandler(event:Event):Void
	{
		this._owner.selectedIndex = -1;
	}
}
