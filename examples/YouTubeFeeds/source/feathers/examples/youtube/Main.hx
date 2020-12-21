package feathers.examples.youtube;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.examples.youtube.models.YouTubeModel;
import feathers.examples.youtube.screens.ListVideosScreen;
import feathers.examples.youtube.screens.MainMenuScreen;
import feathers.examples.youtube.screens.VideoDetailsScreen;
import feathers.motion.Slide;
import feathers.themes.MetalWorksMobileTheme;

import starling.events.Event;

class Main extends StackScreenNavigator
{
	inline private static var MAIN_MENU:String = "mainMenu";
	inline private static var LIST_VIDEOS:String = "listVideos";
	inline private static var VIDEO_DETAILS:String = "videoDetails";

	public function new()
	{
		//set up the theme right away!
		new MetalWorksMobileTheme();
		super();
	}

	private var _model:YouTubeModel;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this._model = new YouTubeModel();

		var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(MainMenuScreen);
		mainMenuItem.setFunctionForPushEvent(MainMenuScreen.LIST_VIDEOS, this.mainMenuScreen_listVideosHandler);
		this.addScreen(MAIN_MENU, mainMenuItem);

		var listVideosItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListVideosScreen);
		listVideosItem.setFunctionForPushEvent(ListVideosScreen.SHOW_VIDEO_DETAILS, this.listVideos_showVideoDetails);
		listVideosItem.addPopEvent(Event.COMPLETE);
		listVideosItem.properties.model = this._model;
		this.addScreen(LIST_VIDEOS, listVideosItem);

		var videoDetailsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VideoDetailsScreen);
		videoDetailsItem.addPopEvent(Event.COMPLETE);
		videoDetailsItem.properties.model = this._model;
		this.addScreen(VIDEO_DETAILS, videoDetailsItem);

		this.rootScreenID = MAIN_MENU;

		this.pushTransition = Slide.createSlideLeftTransition();
		this.popTransition = Slide.createSlideRightTransition();
	}

	private function mainMenuScreen_listVideosHandler(event:Event, mainMenuProperties:Object):Void
	{
		var screen:MainMenuScreen = MainMenuScreen(this.activeScreen);
		this._model.selectedList = screen.selectedCategory;
		this.pushScreen(LIST_VIDEOS, mainMenuProperties);
	}

	private function listVideos_showVideoDetails(event:Event, listVideosProperties:Object):Void
	{
		var screen:ListVideosScreen = ListVideosScreen(this.activeScreen);
		this._model.selectedVideo = screen.selectedVideo;
		this.pushScreen(VIDEO_DETAILS, listVideosProperties);
	}
}
