package feathers.examples.youtube.screens
{
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.youtube.models.VideoFeed;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.StandardIcons;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import starling.events.Event;
import starling.textures.Texture;

[Event(name="listVideos",type="starling.events.Event")]

class MainMenuScreen extends PanelScreen
{
	inline public static var LIST_VIDEOS:String = "listVideos";

	inline private static var PART_PARAMETER:String = "?part=snippet"; //must be first
	inline private static var CHART_PARAMETER:String = "&chart=mostPopular";
	inline private static var REGION_CODE_PARAMETER:String = "&regionCode=US";
	inline private static var MAX_RESULTS_PARAMETER:String = "&maxResults=25";
	inline private static var VIDEO_CATEGORY_ID_PARAMETER:String = "&videoCategoryId=";
	inline private static var KEY_PARAMETER:String = "&key=" + CONFIG::YOUTUBE_API_KEY;
	inline private static var FIELDS_PARAMETER:String = "&fields=items%2Fid%2Citems%2Fsnippet%2Ftitle%2Citems%2Fsnippet%2FchannelTitle%2Citems%2Fsnippet%2Fdescription%2Citems%2Fsnippet%2Fthumbnails";
	inline private static var LIST_CATEGORIES_URL:String = "https://www.googleapis.com/youtube/v3/videoCategories" + PART_PARAMETER + REGION_CODE_PARAMETER + KEY_PARAMETER;
	inline private static var LIST_VIDEOS_IN_CATEGORY_URL:String = "https://www.googleapis.com/youtube/v3/videos" + PART_PARAMETER + CHART_PARAMETER + REGION_CODE_PARAMETER + MAX_RESULTS_PARAMETER + FIELDS_PARAMETER + KEY_PARAMETER + VIDEO_CATEGORY_ID_PARAMETER;

	public function MainMenuScreen()
	{
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _list:List;

	private var _loader:URLLoader;
	private var _message:Label;

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;
	public var savedDataProvider:ListCollection;

	public function get_selectedCategory():VideoFeed
	{
		if(!this._list)
		{
			return null;
		}
		return this._list.selectedItem as VideoFeed;
	}

	override private function initialize():Void
	{
		super.initialize();

		this.title = "YouTube Feeds";

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "name";
			renderer.accessorySourceFunction = accessorySourceFunction;
			return renderer;
		}
		//when navigating to video results, we save this information to
		//restore the list when later navigating back to this screen.
		if(this.savedDataProvider)
		{
			this._list.dataProvider = this.savedDataProvider;
			this._list.selectedIndex = this.savedSelectedIndex;
			this._list.verticalScrollPosition = this.savedVerticalScrollPosition;
		}
		this.addChild(this._list);

		this._message = new Label();
		this._message.text = "Loading...";
		this._message.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
		//hide the loading message if we're using restored results
		this._message.visible = this.savedDataProvider == null;
		this.addChild(this._message);

		this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);

		//only load the list of videos if don't have restored results
		if(!this.savedDataProvider && dataInvalid)
		{
			this._list.dataProvider = null;
			this._message.visible = true;
			if(this._loader)
			{
				this.cleanUpLoader();
			}
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this._loader.load(new URLRequest(LIST_CATEGORIES_URL));
		}

		//never forget to call super.draw()!
		super.draw();
	}

	private function cleanUpLoader():Void
	{
		if(!this._loader)
		{
			return;
		}
		this._loader.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		this._loader = null;
	}

	private function parseListVideoCategoriesResult(result:Object):Void
	{
		this._message.visible = false;

		var items:Array<VideoFeed> = new <VideoFeed>[];
		var categories:Array = result.items as Array;
		var categoryCount:Int = categories.length;
		for(var i:Int = 0; i < categoryCount; i++)
		{
			var category:Object = categories[i];
			var assignable:Bool = category.snippet.assignable as Bool; 
			if(!assignable)
			{
				continue;
			}
			var item:VideoFeed = new VideoFeed();
			item.name = category.snippet.title as String;
			var categoryID:String = category.id as String;
			item.url = LIST_VIDEOS_IN_CATEGORY_URL + categoryID;
			items.push(item);
		}
		var collection:ListCollection = new ListCollection(items);
		this._list.dataProvider = collection;

		//show the scroll bars so that the user knows they can scroll
		this._list.revealScrollBars();
	}

	private function accessorySourceFunction(item:Object):Texture
	{
		return StandardIcons.listDrillDownAccessoryTexture;
	}

	private function removedFromStageHandler(event:starling.events.Event):Void
	{
		this.cleanUpLoader();
	}

	private function transitionInCompleteHandler(event:starling.events.Event):Void
	{
		this._list.selectedIndex = -1;
		this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);

		this._list.revealScrollBars();
	}

	private function list_changeHandler(event:starling.events.Event):Void
	{
		this.dispatchEventWith(LIST_VIDEOS, false,
		{
			//we're going to save the position of the list so that when the user
			//navigates back to this screen, they won't need to scroll back to
			//the same position manually
			savedVerticalScrollPosition: this._list.verticalScrollPosition,
			//we'll also save the selected index to temporarily highlight
			//the previously selected item when transitioning back
			savedSelectedIndex: this._list.selectedIndex,
			//and we'll save the data provider so that we don't need to reload
			//data when we return to this screen. we can restore it.
			savedDataProvider: this._list.dataProvider
		});
	}

	private function loader_completeHandler(event:flash.events.Event):Void
	{
		try
		{
			var loaderData:String = this._loader.data as String;
			this.parseListVideoCategoriesResult(JSON.parse(loaderData));
		}
		catch(error:Error)
		{
			this._message.text = "Unable to load data. Please try again later.";
			this._message.visible = true;
			this.invalidate(INVALIDATION_FLAG_STYLES);
			trace(error.toString());
		}
		this.cleanUpLoader();
	}

	private function loader_errorHandler(event:ErrorEvent):Void
	{
		this.cleanUpLoader();
		this._message.text = "Unable to load data. Please try again later.";
		this._message.visible = true;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		trace(event.toString());
	}
}
}
