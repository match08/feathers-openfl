/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.IScreenNavigatorItem;
import openfl.errors.ArgumentError;

import starling.display.DisplayObject;

/**
 * Data for an individual screen that will be displayed by a
 * <code>ScreenNavigator</code> component.
 *
 * <p>The following example creates a new <code>ScreenNavigatorItem</code>
 * using the <code>SettingsScreen</code> class to instantiate the screen
 * instance. When the screen is shown, its <code>settings</code> property
 * will be set. When the screen instance dispatches
 * <code>Event.COMPLETE</code>, the <code>ScreenNavigator</code> will
 * navigate to a screen with the ID <code>"mainMenu"</code>.</p>
 *
 * <listing version="3.0">
 * var settingsData:Object = { volume: 0.8, difficulty: "hard" };
 * var item:ScreenNavigatorItem = new ScreenNavigatorItem( SettingsScreen );
 * item.properties.settings = settingsData;
 * item.setScreenIDForEvent( Event.COMPLETE, "mainMenu" );
 * navigator.addScreen( "settings", item );</listing>
 *
 * @see ../../../help/screen-navigator.html How to use the Feathers ScreenNavigator component
 * @see feathers.controls.ScreenNavigator
 */
class ScreenNavigatorItem implements IScreenNavigatorItem
{
	/**
	 * Constructor.
	 */
	public function new(screen:Dynamic = null, events:Dynamic= null, properties:Dynamic = null)
	{
		this._screen = screen;
		this._events = events ? events : {};
		this._properties = properties ? properties : {};
	}

	/**
	 * @private
	 */
	private var _screen:Dynamic;
	
	/**
	 * The screen to be displayed by the <code>ScreenNavigator</code>. It
	 * may be one of several possible types:
	 *
	 * <ul>
	 *     <li>a <code>Class</code> that may be instantiated to create a <code>DisplayObject</code></li>
	 *     <li>a <code>Function</code> that returns a <code>DisplayObject</code></li>
	 *     <li>a Starling <code>DisplayObject</code> that is already instantiated</li>
	 * </ul>
	 *
	 * <p>If the screen is a <code>Class</code> or a <code>Function</code>,
	 * a new instance of the screen will be instantiated every time that it
	 * is shown by the <code>ScreenNavigator</code>. The screen's state
	 * will not be saved automatically. The screen's state may be saved in
	 * <code>properties</code>, if needed.</p>
	 *
	 * <p>If the screen is a <code>DisplayObject</code>, the same instance
	 * will be reused every time that it is shown by the
	 * <code>ScreenNavigator</code>. When the screen is shown again, its
	 * state will remain the same as when it was previously hidden. However,
	 * the screen will also be kept in memory even when it isn't visible,
	 * limiting the resources that are available for other screens.</p>
	 *
	 * @default null
	 */
	public var screen(get, set):Dynamic;
	public function get_screen():Dynamic
	{
		return this._screen;
	}

	/**
	 * @private
	 */
	public function set_screen(value:Dynamic):Dynamic
	{
		this._screen = value;
		return get_screen();
	}

	/**
	 * @private
	 */
	private var _events:Dynamic;
	
	/**
	 * A set of key-value pairs representing actions that should be
	 * triggered when events are dispatched by the screen when it is shown.
	 * A pair's key is the event type to listen for (or the property name of
	 * an <code>ISignal</code> instance), and a pair's value is one of two
	 * possible types. When this event is dispatched, and a pair's value
	 * is a <code>String</code>, the <code>ScreenNavigator</code> will show
	 * another screen with an ID equal to the string value. When this event
	 * is dispatched, and the pair's value is a <code>Function</code>, the
	 * function will be called as if it were a listener for the event.
	 *
	 * @see #setFunctionForEvent()
	 * @see #setScreenIDForEvent()
	 */
	public var events(get, set):Dynamic;
	public function get_events():Dynamic
	{
		return this._events;
	}

	/**
	 * @private
	 */
	public function set_events(value:Dynamic):Dynamic
	{
		if(!value)
		{
			value = {};
		}
		this._events = value;
		return get_events();
	}

	/**
	 * @private
	 */
	private var _properties:Dynamic;
	
	/**
	 * A set of key-value pairs representing properties to be set on the
	 * screen when it is shown. A pair's key is the name of the screen's
	 * property, and a pair's value is the value to be passed to the
	 * screen's property.
	 */
	public var properties(get, set):Dynamic;
	public function get_properties():Dynamic
	{
		return this._properties;
	}

	/**
	 * @private
	 */
	public function set_properties(value:Dynamic):Dynamic
	{
		if(!value)
		{
			value = {};
		}
		this._properties = value;
		return get_properties();
	}

	/**
	 * @inheritDoc
	 */
	public var canDispose(get, never):Bool;
	public function get_canDispose():Bool
	{
		return !Std.is(this._screen, DisplayObject);
	}

	/**
	 * Specifies a function to call when an event is dispatched by the
	 * screen.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>ScreenNavigator</code>, and you call
	 * <code>setFunctionForEvent()</code> on the <code>ScreenNavigatorItem</code>,
	 * the <code>ScreenNavigator</code> won't listen for the event until
	 * the next time that the screen is shown.</p>
	 *
	 * @see #setScreenIDForEvent()
	 * @see #clearEvent()
	 * @see #events
	 */
	public function setFunctionForEvent(eventType:String, action:Dynamic):Void
	{
		Reflect.setField(this._events, eventType, action);
	}

	/**
	 * Specifies another screen to navigate to when an event is dispatched
	 * by this screen. The other screen should be specified by its ID that
	 * is registered with the <code>ScreenNavigator</code>.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>ScreenNavigator</code>, and you call
	 * <code>setScreenIDForEvent()</code> on the <code>ScreenNavigatorItem</code>,
	 * the <code>ScreenNavigator</code> won't listen for the event until the
	 * next time that the screen is shown.</p>
	 *
	 * @see #setFunctionForEvent()
	 * @see #clearEvent()
	 * @see #events
	 */
	public function setScreenIDForEvent(eventType:String, screenID:String):Void
	{
		Reflect.setField(this._events, eventType, screenID);
	}

	/**
	 * Cancels the action previously registered to be triggered when the
	 * screen dispatches an event.
	 *
	 * @see #events
	 */
	public function clearEvent(eventType:String):Void
	{
		Reflect.deleteField(this._events, eventType);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getScreen():DisplayObject
	{
		var screenInstance:DisplayObject;
		if(Std.is(this._screen, Class))
		{
			var ScreenType:Class<Dynamic> = cast this._screen;
			screenInstance = Type.createInstance(ScreenType, []);
		}
		else if(Reflect.isFunction(this._screen))
		{
			screenInstance = cast(this._screen(), DisplayObject);
		}
		else
		{
			screenInstance = cast(this._screen, DisplayObject);
		}
		if(!Std.is(screenInstance, DisplayObject))
		{
			throw new ArgumentError("ScreenNavigatorItem \"getScreen()\" must return a Starling display object.");
		}
		
		if(this._properties)
		{
			for(propertyName in Reflect.fields(this._properties))
			{
				Reflect.setProperty(screenInstance, propertyName, Reflect.field(this._properties, propertyName));
			}
		}
		
		return screenInstance;
	}
}