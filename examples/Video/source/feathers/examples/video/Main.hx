package feathers.examples.video;
import feathers.controls.ImageLoader;
import feathers.controls.LayoutGroup;
import feathers.events.MediaPlayerEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.HorizontalLayoutData;
import feathers.media.FullScreenToggleButton;
import feathers.media.MuteToggleButton;
import feathers.media.PlayPauseToggleButton;
import feathers.media.SeekSlider;
import feathers.media.VideoPlayer;
import feathers.themes.MetalWorksDesktopTheme;

// #if 0
// import flash.desktop.NativeApplication;
// import flash.display.NativeMenu;
// import flash.display.NativeMenuItem;
// #end
// import flash.events.ContextMenuEvent;
// #if 0
// import flash.filesystem.File;
// #end
// import flash.net.FileFilter;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

class Main extends Sprite
{
	public function new()
	{
		new MetalWorksDesktopTheme();
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	private var _videoPlayer:VideoPlayer;
	private var _controls:LayoutGroup;
	private var _playPauseButton:PlayPauseToggleButton;
	private var _seekSlider:SeekSlider;
	private var _muteButton:MuteToggleButton;
	private var _fullScreenButton:FullScreenToggleButton;
	private var _view:ImageLoader;
	
	#if 0
	private var _fullScreenItem:NativeMenuItem;
	private var _fileToOpen:File;
	#end
	
	private function addedToStageHandler(event:starling.events.Event):Void
	{
		this.createMenu();
		
		this._videoPlayer = new VideoPlayer();
		this._videoPlayer.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
		this._videoPlayer.layout = new AnchorLayout();
		this._videoPlayer.addEventListener(Event.READY, videoPlayer_readyHandler);
		this._videoPlayer.addEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, videoPlayer_displayStateChangeHandler);
		this.addChild(this._videoPlayer);
		
		this._view = new ImageLoader();
		this._videoPlayer.addChild(this._view);
		
		this._controls = new LayoutGroup();
		this._controls.touchable = false;
		this._controls.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
		this._videoPlayer.addChild(this._controls);
		
		this._playPauseButton = new PlayPauseToggleButton();
		this._controls.addChild(this._playPauseButton);
		
		this._seekSlider = new SeekSlider();
		this._seekSlider.layoutData = new HorizontalLayoutData(100);
		this._controls.addChild(this._seekSlider);
		
		this._muteButton = new MuteToggleButton();
		this._controls.addChild(this._muteButton);

		this._fullScreenButton = new FullScreenToggleButton();
		this._controls.addChild(this._fullScreenButton);
		
		var controlsLayoutData:AnchorLayoutData = new AnchorLayoutData();
		controlsLayoutData.left = 0;
		controlsLayoutData.right = 0;
		controlsLayoutData.bottom = 0;
		this._controls.layoutData = controlsLayoutData;

		var viewLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
		viewLayoutData.bottomAnchorDisplayObject = this._controls;
		this._view.layoutData = viewLayoutData;
	}
	
	private function createMenu():Void
	{
		#if 0
		var menu:NativeMenu;
		if(NativeApplication.supportsMenu)
		{
			menu = NativeApplication.nativeApplication.menu;
			var applicationMenuItem:NativeMenuItem = menu.getItemAt(0);
			menu.removeAllItems();
			menu.addItem(applicationMenuItem);
		}
		else
		{
			menu = new NativeMenu();
			Starling.current.nativeStage.nativeWindow.menu = menu;
		}

		var fileMenuItem:NativeMenuItem = new NativeMenuItem("File");
		var fileMenu:NativeMenu = new NativeMenu();
		fileMenuItem.submenu = fileMenu;
		menu.addItem(fileMenuItem);
		var openItem:NativeMenuItem = new NativeMenuItem("Open");
		openItem.keyEquivalent = "o";
		openItem.addEventListener(openfl.events.Event.SELECT, openItem_selectHandler);
		fileMenu.addItem(openItem);
		var closeItem:NativeMenuItem = new NativeMenuItem("Close");
		closeItem.keyEquivalent = "w";
		closeItem.addEventListener(openfl.events.Event.SELECT, closeItem_selectHandler);
		fileMenu.addItem(closeItem);

		var viewMenuItem:NativeMenuItem = new NativeMenuItem("View");
		var viewMenu:NativeMenu = new NativeMenu();
		viewMenuItem.submenu = viewMenu;
		menu.addItem(viewMenuItem);
		this._fullScreenItem = new NativeMenuItem("Enter Full Screen");
		this._fullScreenItem.keyEquivalent = "f";
		this._fullScreenItem.addEventListener(openfl.events.Event.SELECT, fullScreenItem_selectHandler);
		viewMenu.addItem(this._fullScreenItem);
		
		if(NativeApplication.supportsMenu)
		{
			var windowMenuItem:NativeMenuItem = new NativeMenuItem("Window");
			var windowMenu:NativeMenu = new NativeMenu();
			windowMenuItem.submenu = windowMenu;
			menu.addItem(windowMenuItem);
			var minimizeItem:NativeMenuItem = new NativeMenuItem("Minimize");
			minimizeItem.keyEquivalent = "m";
			minimizeItem.addEventListener(openfl.events.Event.SELECT, minimizeItem_selectHandler);
			windowMenu.addItem(minimizeItem);
			var zoomItem:NativeMenuItem = new NativeMenuItem("Zoom");
			zoomItem.addEventListener(openfl.events.Event.SELECT, zoomItem_selectHandler);
			windowMenu.addItem(zoomItem);
		}
		#end
	}
	
	private function videoPlayer_readyHandler(event:Event):Void
	{
		this._view.source = this._videoPlayer.texture;
		this._controls.touchable = true;
	}

	private function videoPlayer_displayStateChangeHandler(event:Event):Void
	{
		#if 0
		this._fullScreenItem.label = this._videoPlayer.isFullScreen ? "Exit Full Screen" : "Enter Full Screen";
		#end
	}
	
	private function openItem_selectHandler(event:openfl.events.Event):Void
	{
		#if 0
		this._fileToOpen = new File();
		this._fileToOpen.addEventListener(openfl.events.Event.SELECT, fileToOpen_selectHandler);
		this._fileToOpen.addEventListener(openfl.events.Event.CANCEL, fileToOpen_cancelHandler);
		this._fileToOpen.browseForOpen("Select video file",
		[
			new FileFilter("Video files", "*.m4v;*.mp4;*.f4v;*.flv;*.mov")
		]);
		#end
	}
	
	private function closeItem_selectHandler(event:openfl.events.Event):Void
	{
		//we don't need to dispose the texture here. the VideoPlayer will
		//do it automatically when videoSource is changed.
		this._view.source = null;
		this._videoPlayer.videoSource = null;
		this._controls.touchable = false;
	}
	
	private function fileToOpen_cancelHandler(event:openfl.events.Event):Void
	{
		#if 0
		this._fileToOpen.removeEventListener(openfl.events.Event.SELECT, fileToOpen_selectHandler);
		this._fileToOpen.removeEventListener(openfl.events.Event.CANCEL, fileToOpen_cancelHandler);
		this._fileToOpen = null;
		#end
	}

	private function fileToOpen_selectHandler(event:openfl.events.Event):Void
	{
		#if 0
		if(this._videoPlayer.videoSource == this._fileToOpen.url)
		{
			//it's the same file, so just start it over instead of trying
			//to load it again!
			this._videoPlayer.stop();
			this._videoPlayer.play();
			return;
		}
		#end
		this._controls.touchable = false;
		#if 0
		this._videoPlayer.videoSource = this._fileToOpen.url;
		this._fileToOpen.removeEventListener(openfl.events.Event.SELECT, fileToOpen_selectHandler);
		this._fileToOpen.removeEventListener(openfl.events.Event.CANCEL, fileToOpen_cancelHandler);
		this._fileToOpen = null;
		#end
	}
	
	private function fullScreenItem_selectHandler(event:openfl.events.Event):Void
	{
		this._videoPlayer.toggleFullScreen();
	}
	
	private function minimizeItem_selectHandler(event:openfl.events.Event):Void
	{
		#if 0
		Starling.current.nativeStage.nativeWindow.minimize();
		#end
	}

	private function zoomItem_selectHandler(event:openfl.events.Event):Void
	{
		#if 0
		Starling.current.nativeStage.nativeWindow.maximize();
		#end
	}
}
