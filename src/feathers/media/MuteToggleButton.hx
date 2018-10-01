/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.controls.ToggleButton;
import feathers.controls.popups.DropDownPopUpContentManager;
import feathers.controls.popups.IPopUpContentManager;
import feathers.core.PropertyProxy;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;

import flash.media.SoundTransform;

import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import feathers.utils.type.SafeCast.safe_cast;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Dispatched when the pop-up volume slider is opened.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.OPEN
 */
#if 0
[Event(name="open",type="starling.events.Event")]
#end

/**
 * Dispatched when the pop-up volume slider is closed.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CLOSE
 */
#if 0
[Event(name="close",type="starling.events.Event")]
#end

/**
 * A specialized toggle button that controls whether a media player's volume
 * is muted or not.
 *
 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
 */
class MuteToggleButton extends ToggleButton implements IMediaPlayerControl
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY:String = "volumeSliderFactory";
	
	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * pop-up volume slider.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER:String = "feathers-volume-toggle-button-volume-slider";
	
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>MuteToggleButton</code> components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultVolumeSliderFactory():VolumeSlider
	{
		var slider:VolumeSlider = new VolumeSlider();
		slider.direction = VolumeSlider.DIRECTION_VERTICAL;
		return slider;
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.CHANGE, muteToggleButton_changeHandler);
		this.addEventListener(TouchEvent.TOUCH, muteToggleButton_touchHandler);
	}

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * pop-up volume slider. This variable is <code>protected</code> so that
	 * sub-classes can customize the list style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER</code>.
	 *
	 * <p>To customize the pop-up list name without subclassing, see
	 * <code>customListStyleName</code>.</p>
	 *
	 * @see #customListStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var volumeSliderStyleName:String = DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER;

	/**
	 * @private
	 */
	private var slider:VolumeSlider;

	/**
	 * @private
	 */
	private var _oldVolume:Float;

	/**
	 * @private
	 */
	private var _ignoreChanges:Bool = false;

	/**
	 * @private
	 */
	private var _touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _popUpTouchPointID:Int = -1;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return MuteToggleButton.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _mediaPlayer:IAudioPlayer;

	/**
	 * @inheritDoc
	 */
	public var mediaPlayer(get, set):IMediaPlayer;
	public function get_mediaPlayer():IMediaPlayer
	{
		return this._mediaPlayer;
	}

	/**
	 * @private
	 */
	public function set_mediaPlayer(value:IMediaPlayer):IMediaPlayer
	{
		if(this._mediaPlayer == value)
		{
			return get_mediaPlayer();
		}
		this._mediaPlayer = safe_cast(value, IAudioPlayer);
		this.refreshVolumeFromMediaPlayer();
		if(this._mediaPlayer != null)
		{
			this._mediaPlayer.addEventListener(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE, mediaPlayer_soundTransformChangeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_mediaPlayer();
	}

	/**
	 * @private
	 */
	private var _popUpContentManager:IPopUpContentManager;

	/**
	 * A manager that handles the details of how to display the pop-up
	 * volume slider.
	 *
	 * <p>In the following example, a pop-up content manager is provided:</p>
	 *
	 * <listing version="3.0">
	 * button.popUpContentManager = new CalloutPopUpContentManager();</listing>
	 *
	 * @default null
	 */
	public var popUpContentManager(get, set):IPopUpContentManager;
	public function get_popUpContentManager():IPopUpContentManager
	{
		return this._popUpContentManager;
	}

	/**
	 * @private
	 */
	public function set_popUpContentManager(value:IPopUpContentManager):IPopUpContentManager
	{
		if(this._popUpContentManager == value)
		{
			return get_popUpContentManager();
		}
		var dispatcher:EventDispatcher;
		if(Std.is(this._popUpContentManager, EventDispatcher))
		{
			dispatcher = cast(this._popUpContentManager, EventDispatcher);
			dispatcher.removeEventListener(Event.OPEN, popUpContentManager_openHandler);
			dispatcher.removeEventListener(Event.CLOSE, popUpContentManager_closeHandler);
		}
		this._popUpContentManager = value;
		if(Std.is(this._popUpContentManager, EventDispatcher))
		{
			dispatcher = cast(this._popUpContentManager, EventDispatcher);
			dispatcher.addEventListener(Event.OPEN, popUpContentManager_openHandler);
			dispatcher.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_popUpContentManager();
	}

	/**
	 * @private
	 */
	private var _showVolumeSliderOnHover:Bool = false;

	/**
	 * Determines if a <code>VolumeSlider</code> component is displayed as a
	 * pop-up when hovering over the toggle button. This property is
	 * intended for use on desktop platforms only. On mobile platforms,
	 * Starling does not dispatch events for hover, so the volume slider
	 * will not be shown.
	 *
	 * <p>In the following example, showing the volume slider is enabled:</p>
	 *
	 * <listing version="3.0">
	 * button.showVolumeSliderOnHover = true;</listing>
	 *
	 * @default false
	 *
	 * @see feathers.media.VolumeSlider
	 */
	public var showVolumeSliderOnHover(get, set):Bool;
	public function get_showVolumeSliderOnHover():Bool
	{
		return this._showVolumeSliderOnHover;
	}

	/**
	 * @private
	 */
	public function set_showVolumeSliderOnHover(value:Bool):Bool
	{
		if(this._showVolumeSliderOnHover == value)
		{
			return get_showVolumeSliderOnHover();
		}
		this._showVolumeSliderOnHover = value;
		this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		return get_showVolumeSliderOnHover();
	}

	/**
	 * @private
	 */
	private var _volumeSliderFactory:Void->VolumeSlider;

	/**
	 * A function used to generate the button's pop-up volume slider
	 * sub-component. The volume slider must be an instance of
	 * <code>VolumeSlider</code>. This factory can be used to change
	 * properties on the volume slider when it is first created. For
	 * instance, if you are skinning Feathers components without a theme,
	 * you might use this factory to set skins and other styles on the
	 * volume slider.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():VolumeSlider</pre>
	 *
	 * <p>In the following example, a custom volume slider factory is passed
	 * to the button:</p>
	 *
	 * <listing version="3.0">
	 * button.volumeSliderFactory = function():VolumeSlider
	 * {
	 *     var popUpSlider:VolumeSlider = new VolumeSlider();
	 *     popUpSlider.direction = VolumeSlider.DIRECTION_VERTICAL;
	 *     return popUpSlider;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.media.VolumeSlider
	 * @see #showVolumeSliderOnHover
	 * @see #volumeSliderProperties
	 */
	public var volumeSliderFactory(get, set):Void->VolumeSlider;
	public function get_volumeSliderFactory():Void->VolumeSlider
	{
		return this._volumeSliderFactory;
	}

	/**
	 * @private
	 */
	public function set_volumeSliderFactory(value:Void->VolumeSlider):Void->VolumeSlider
	{
		if(this._volumeSliderFactory == value)
		{
			return get_volumeSliderFactory();
		}
		this._volumeSliderFactory = value;
		this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		return get_volumeSliderFactory();
	}

	/**
	 * @private
	 */
	private var _customVolumeSliderStyleName:String;

	/**
	 * A style name to add to the button's volume slider sub-component.
	 * Typically used by a theme to provide different styles to different
	 * buttons.
	 *
	 * <p>In the following example, a custom volume slider style name is
	 * passed to the button:</p>
	 *
	 * <listing version="3.0">
	 * button.customVolumeSliderStyleName = "my-custom-volume-slider";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to provide
	 * different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( VolumeSlider ).setFunctionForStyleName( "my-custom-volume-slider", setCustomVolumeSliderStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #showVolumeSliderOnHover
	 * @see #DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #volumeSliderFactory
	 * @see #volumeSliderProperties
	 */
	public var customVolumeSliderStyleName(get, set):String;
	public function get_customVolumeSliderStyleName():String
	{
		return this._customVolumeSliderStyleName;
	}

	/**
	 * @private
	 */
	public function set_customVolumeSliderStyleName(value:String):String
	{
		if(this._customVolumeSliderStyleName == value)
		{
			return get_customVolumeSliderStyleName();
		}
		this._customVolumeSliderStyleName = value;
		this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		return get_customVolumeSliderStyleName();
	}

	/**
	 * @private
	 */
	private var _volumeSliderProperties:PropertyProxy;

	/**
	 * An object that stores properties for the button's pop-up volume
	 * slider sub-component, and the properties will be passed down to the
	 * volume slider when the button validates. For a list of available
	 * properties, refer to <a href="VolumeSlider.html"><code>feathers.media.VolumeSlider</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>volumeSliderFactory</code> function
	 * instead of using <code>volumeSliderProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the volume slider properties are passed
	 * to the button:</p>
	 *
	 * <listing version="3.0">
	 * button.volumeSliderProperties.direction = VolumeSlider.DIRECTION_VERTICAL;</listing>
	 *
	 * @default null
	 *
	 * @see #showVolumeSliderOnHover
	 * @see #volumeSliderFactory
	 * @see feathers.media.VolumeSlider
	 */
	public var volumeSliderProperties(get, set):PropertyProxy;
	public function get_volumeSliderProperties():PropertyProxy
	{
		if(this._volumeSliderProperties == null)
		{
			this._volumeSliderProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._volumeSliderProperties;
	}

	/**
	 * @private
	 */
	public function set_volumeSliderProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._volumeSliderProperties == value)
		{
			return get_volumeSliderProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!Std.is(value, PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(propertyName in Reflect.fields(value))
			{
				Reflect.setProperty(newValue.storage, propertyName, Reflect.field(value, propertyName));
			}
			value = newValue;
		}
		if(this._volumeSliderProperties != null)
		{
			this._volumeSliderProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._volumeSliderProperties = value;
		if(this._volumeSliderProperties != null)
		{
			this._volumeSliderProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_volumeSliderProperties();
	}

	/**
	 * @private
	 */
	private var _isOpenPopUpPending:Bool = false;

	/**
	 * @private
	 */
	private var _isClosePopUpPending:Bool = false;

	/**
	 * Opens the pop-up list, if it isn't already open.
	 */
	public function openPopUp():Void
	{
		this._isClosePopUpPending = false;
		if(this._popUpContentManager.isOpen)
		{
			return;
		}
		if(!this._isValidating && this.isInvalid())
		{
			this._isOpenPopUpPending = true;
			return;
		}
		this._isOpenPopUpPending = false;
		this._popUpContentManager.open(this.slider, this);
		this.slider.validate();
		this._popUpTouchPointID = -1;
		this.slider.addEventListener(TouchEvent.TOUCH, volumeSlider_touchHandler);
	}

	/**
	 * Closes the pop-up list, if it is open.
	 */
	public function closePopUp():Void
	{
		this._isOpenPopUpPending = false;
		if(!this._popUpContentManager.isOpen)
		{
			return;
		}
		if(!this._isValidating && this.isInvalid())
		{
			this._isClosePopUpPending = true;
			return;
		}
		this._isClosePopUpPending = false;
		this.slider.validate();
		//don't clean up anything from openList() in closeList(). The list
		//may be closed by removing it from the PopUpManager, which would
		//result in closeList() never being called.
		//instead, clean up in the Event.REMOVED_FROM_STAGE listener.
		this._popUpContentManager.close();
	}

	/**
	 * @inheritDoc
	 */
	override public function dispose():Void
	{
		if(this.slider != null)
		{
			this.closePopUp();
			this.slider.mediaPlayer = null;
			this.slider.dispose();
			this.slider = null;
		}
		if(this._popUpContentManager != null)
		{
			this._popUpContentManager.dispose();
			this._popUpContentManager = null;
		}
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._popUpContentManager == null)
		{
			var popUpContentManager:DropDownPopUpContentManager = new DropDownPopUpContentManager();
			popUpContentManager.fitContentMinWidthToOrigin = false;
			popUpContentManager.primaryDirection = DropDownPopUpContentManager.PRIMARY_DIRECTION_UP;
			this.popUpContentManager = popUpContentManager;
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var volumeSliderFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		
		if(volumeSliderFactoryInvalid)
		{
			this.createVolumeSlider();
		}

		if(this.slider != null && (volumeSliderFactoryInvalid || stylesInvalid))
		{
			this.refreshVolumeSliderProperties();
		}
		
		super.draw();
		
		this.handlePendingActions();
	}

	/**
	 * Creates and adds the <code>list</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #list
	 * @see #listFactory
	 * @see #customListStyleName
	 */
	private function createVolumeSlider():Void
	{
		if(this.slider != null)
		{
			this.slider.removeFromParent(false);
			//disposing separately because the slider may not have a parent
			this.slider.dispose();
			this.slider = null;
		}
		if(!this._showVolumeSliderOnHover)
		{
			return;
		}

		var factory:Void->VolumeSlider = this._volumeSliderFactory != null ? this._volumeSliderFactory : defaultVolumeSliderFactory;
		var volumeSliderStyleName:String = this._customVolumeSliderStyleName != null ? this._customVolumeSliderStyleName : this.volumeSliderStyleName;
		this.slider = factory();
		this.slider.focusOwner = this;
		this.slider.styleNameList.add(volumeSliderStyleName);
	}

	/**
	 * @private
	 */
	private function refreshVolumeSliderProperties():Void
	{
		if (this._volumeSliderProperties != null)
			for(propertyName in Reflect.fields(this._volumeSliderProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._volumeSliderProperties.storage, propertyName);
				Reflect.setProperty(this.slider, propertyName, propertyValue);
			}
		this.slider.mediaPlayer = this._mediaPlayer;
	}

	/**
	 * @private
	 */
	private function handlePendingActions():Void
	{
		if(this._isOpenPopUpPending)
		{
			this.openPopUp();
		}
		if(this._isClosePopUpPending)
		{
			this.closePopUp();
		}
	}

	/**
	 * @private
	 */
	private function refreshVolumeFromMediaPlayer():Void
	{
		var oldIgnoreChanges:Bool = this._ignoreChanges;
		this._ignoreChanges = true;
		if(this._mediaPlayer != null)
		{
			this.isSelected = this._mediaPlayer.soundTransform.volume == 0;
		}
		else
		{
			this.isSelected = false;
		}
		this._ignoreChanges = oldIgnoreChanges;
	}

	/**
	 * @private
	 */
	private function mediaPlayer_soundTransformChangeHandler(event:Event):Void
	{
		this.refreshVolumeFromMediaPlayer();
	}

	/**
	 * @private
	 */
	private function muteToggleButton_changeHandler(event:Event):Void
	{
		if(this._ignoreChanges || this._mediaPlayer == null)
		{
			return;
		}
		var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
		if(this._isSelected)
		{
			this._oldVolume = soundTransform.volume;
			if(this._oldVolume == 0)
			{
				this._oldVolume = 1;
			}
			soundTransform.volume = 0;
			this._mediaPlayer.soundTransform = soundTransform;
		}
		else
		{
			var newVolume:Float = this._oldVolume;
			if(newVolume != newVolume) //isNaN
			{
				//volume was already zero, so we should fall back to some
				//default value
				newVolume = 1;
			}
			soundTransform.volume = newVolume;
			this._mediaPlayer.soundTransform = soundTransform;
		}
	}

	/**
	 * @private
	 */
	private function muteToggleButton_touchHandler(event:TouchEvent):Void
	{
		if(this.slider == null)
		{
			this._touchPointID = -1;
			return;
		}
		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this, null, this._touchPointID);
			if(touch != null)
			{
				return;
			}
			this._touchPointID = -1;
			touch = event.getTouch(this.slider);
			if(this._popUpTouchPointID < 0 && touch == null)
			{
				this.closePopUp();
			}
		}
		else
		{
			touch = event.getTouch(this, TouchPhase.HOVER);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = touch.id;
			this.openPopUp();
		}
	}

	/**
	 * @private
	 */
	private function volumeSlider_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch;
		if(this._popUpTouchPointID >= 0)
		{
			touch = event.getTouch(this.slider, null, this._popUpTouchPointID);
			if(touch != null)
			{
				return;
			}
			this._popUpTouchPointID = -1;
			touch = event.getTouch(this);
			if(this._touchPointID < 0 && touch == null)
			{
				this.closePopUp();
			}
		}
		else
		{
			touch = event.getTouch(this.slider, TouchPhase.HOVER);
			if(touch == null)
			{
				return;
			}
			this._popUpTouchPointID = touch.id;
		}
	}

	/**
	 * @private
	 */
	private function popUpContentManager_openHandler(event:Event):Void
	{
		this.dispatchEventWith(Event.OPEN);
	}

	/**
	 * @private
	 */
	private function popUpContentManager_closeHandler(event:Event):Void
	{
		this.slider.removeEventListener(TouchEvent.TOUCH, volumeSlider_touchHandler);
		this.dispatchEventWith(Event.CLOSE);
	}
}
