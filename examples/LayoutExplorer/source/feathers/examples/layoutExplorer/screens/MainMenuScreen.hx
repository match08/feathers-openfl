package feathers.examples.layoutExplorer.screens;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.StandardIcons;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.Texture;
#if 0
[Event(name="showAnchor",type="starling.events.Event")]
[Event(name="showHorizontal",type="starling.events.Event")]
[Event(name="showVertical",type="starling.events.Event")]
[Event(name="showTiledRows",type="starling.events.Event")]
[Event(name="showTiledColumns",type="starling.events.Event")]

[Event(name="showAnchor",type="starling.events.Event")]

[Event(name="showFlow",type="starling.events.Event")]

[Event(name="showHorizontal",type="starling.events.Event")]

[Event(name="showVertical",type="starling.events.Event")]

[Event(name="showTiledRows",type="starling.events.Event")]

[Event(name="showTiledColumns",type="starling.events.Event")]

[Event(name="showWaterfall",type="starling.events.Event")]
#end

class MainMenuScreen extends PanelScreen
{
	inline public static var SHOW_ANCHOR:String = "showAnchor";
	inline public static var SHOW_FLOW:String = "showFlow";
	inline public static var SHOW_HORIZONTAL:String = "showHorizontal";
	inline public static var SHOW_VERTICAL:String = "showVertical";
	inline public static var SHOW_TILED_ROWS:String = "showTiledRows";
	inline public static var SHOW_TILED_COLUMNS:String = "showTiledColumns";
	inline public static var SHOW_WATERFALL:String = "showWaterfall";

	public function new()
	{
		super();
	}

	private var _list:List;

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Layouts in Feathers";

		var isTablet:Bool = DeviceCapabilities.isTablet(Starling.current.nativeStage);

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.dataProvider = new ListCollection(
		[
			{ text: "Anchor", event: SHOW_ANCHOR },
			{ text: "Flow", event: SHOW_FLOW },
			{ text: "Horizontal", event: SHOW_HORIZONTAL },
			{ text: "Vertical", event: SHOW_VERTICAL },
			{ text: "Tiled Rows", event: SHOW_TILED_ROWS },
			{ text: "Tiled Columns", event: SHOW_TILED_COLUMNS },
			{ text: "Waterfall", event: SHOW_WATERFALL },
		]);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.verticalScrollPosition = this.savedVerticalScrollPosition;

		var itemRendererAccessorySourceFunction:Dynamic = null;
		if(!isTablet)
		{
			itemRendererAccessorySourceFunction = this.accessorySourceFunction;
		}
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "text";
			renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
			return renderer;
		};

		if(isTablet)
		{
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this._list.selectedIndex = 0;
			this._list.revealScrollBars();
		}
		else
		{
			this._list.selectedIndex = this.savedSelectedIndex;
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		this.addChild(this._list);
	}

	private function accessorySourceFunction(item:Dynamic):Texture
	{
		return StandardIcons.listDrillDownAccessoryTexture;
	}

	private function transitionInCompleteHandler(event:Event):Void
	{
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this._list.selectedIndex = -1;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
		}
		this._list.revealScrollBars();
	}

	private function list_changeHandler(event:Event):Void
	{
		var eventType:String = cast(this._list.selectedItem.event, String);
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.dispatchEventWith(eventType);
			return;
		}

		//save the list's scroll position and selected index so that we
		//can restore some context when this screen when we return to it
		//again later.
		this.dispatchEventWith(eventType, false,
		{
			savedVerticalScrollPosition: this._list.verticalScrollPosition,
			savedSelectedIndex: this._list.selectedIndex
		});

	}
}
