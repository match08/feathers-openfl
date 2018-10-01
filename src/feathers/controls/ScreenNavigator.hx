/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.BaseScreenNavigator;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import openfl.errors.Error;
import openfl.errors.TypeError;
import openfl.utils.Dictionary;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * A "view stack"-like container that supports navigation between screens
 * (any display object) through events.
 *
 * <p>The following example creates a screen navigator, adds a screen and
 * displays it:</p>
 *
 * <listing version="3.0">
 * var navigator:ScreenNavigator = new ScreenNavigator();
 * navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen ) );
 * this.addChild( navigator );
 * navigator.showScreen( "mainMenu" );</listing>
 *
 * @see ../../../help/screen-navigator.html How to use the Feathers ScreenNavigator component
 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
 * @see feathers.controls.ScreenNavigatorItem
 */
class ScreenNavigator extends BaseScreenNavigator
{
	/**
	 * The screen navigator will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The screen navigator will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScreenNavigator</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScreenNavigator.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _transition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function is called when a new screen is shown. 
	 *
	 * <p>In the following example, the screen navigator is given a
	 * transition that fades in the new screen on top of the old screen:</p>
	 *
	 * <listing version="3.0">
	 * navigator.transition = Fade.createFadeInTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Dynamic):Void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes.This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see #showScreen()
	 * @see #clearScreen()
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var transition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_transition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._transition;
	}

	/**
	 * @private
	 */
	public function set_transition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		if(this._transition == value)
		{
			return get_transition();
		}
		this._transition = value;
		return get_transition();
	}

	/**
	 * @private
	 */
	private var _screenEvents:Map<String, Map<String, Dynamic->Void>> = new Map();

	/**
	 * Registers a new screen with a string identifier that can be used
	 * to reference the screen in other calls, like <code>removeScreen()</code>
	 * or <code>showScreen()</code>.
	 *
	 * @see #removeScreen()
	 */
	public function addScreen(id:String, item:ScreenNavigatorItem):Void
	{
		this.addScreenInternal(id, item);
	}

	/**
	 * Removes an existing screen using the identifier assigned to it in the
	 * call to <code>addScreen()</code>.
	 *
	 * @see #removeAllScreens()
	 * @see #addScreen()
	 */
	public function removeScreen(id:String):ScreenNavigatorItem
	{
		return cast(this.removeScreenInternal(id), ScreenNavigatorItem);
	}

	/**
	 * Returns the <code>ScreenNavigatorItem</code> instance with the
	 * specified identifier.
	 */
	public function getScreen(id:String):ScreenNavigatorItem
	{
		return cast(this._screens[id], ScreenNavigatorItem);
	}

	/**
	 * Displays a screen and returns a reference to it. If a previous
	 * transition is running, the new screen will be queued, and no
	 * reference will be returned.
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>transition</code> property will be used instead.</p>
	 *
	 * @see #transition
	 */
	public function showScreen(id:String, transition:DisplayObject->DisplayObject->Dynamic->Void = null):DisplayObject
	{
		if(transition == null)
		{
			transition = this._transition;
		}
		return this.showScreenInternal(id, transition);
	}

	/**
	 * Removes the current screen, leaving the <code>ScreenNavigator</code>
	 * empty.
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>transition</code> property will be used instead.</p>
	 *
	 * @see #transition
	 */
	public function clearScreen(transition:DisplayObject->DisplayObject->Dynamic->Void = null):Void
	{
		if(transition == null)
		{
			transition = this._transition;
		}
		this.clearScreenInternal(transition);
		this.dispatchEventWith(FeathersEventType.CLEAR);
	}

	/**
	 * @private
	 */
	override private function prepareActiveScreen():Void
	{
		
		
	//	trace("prepareActiveScreen:");
		var item:ScreenNavigatorItem = cast(this._screens[this._activeScreenID], ScreenNavigatorItem);
		var events:Dictionary<String,String> = item.events;
		var savedScreenEvents:Map<String, Dynamic->Void> = new Map();
		for (eventName in events.iterator())
		{
			
			//trace("**screen has event called:"+eventName);
			
			var prop = Reflect.getProperty(this._activeScreen, eventName);
			var signal:Dynamic =  prop/* != null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
			var eventAction:Dynamic = events[eventName];
			if(Reflect.isFunction(eventAction))
			{
				if(signal != null)
				{
					signal.add(eventAction);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, eventAction);
				}
			}
			else if(Std.is(eventAction, String))
			{
				var eventListener:Dynamic;
				if(signal != null)
				{
					eventListener = this.createShowScreenSignalListener(cast(eventAction, String), signal);
					signal.add(eventListener);
				}
				else
				{
					eventListener = this.createShowScreenEventListener(cast(eventAction, String));
					this._activeScreen.addEventListener(eventName, eventListener);
				}
				savedScreenEvents[eventName] = eventListener;
			}
			else
			{
				throw new TypeError("Unknown event action defined for screen:" + eventAction.toString());
			}
		}
		this._screenEvents[this._activeScreenID] = savedScreenEvents;
	}

	/**
	 * @private
	 */
	override private function cleanupActiveScreen():Void
	{
		var item:ScreenNavigatorItem = cast(this._screens[this._activeScreenID], ScreenNavigatorItem);
		var events:Dictionary<String,String> = item.events;
		var savedScreenEvents:Map<String, Dynamic->Void> = this._screenEvents[this._activeScreenID];
		for (eventName in events)
		{
			var prop = Reflect.getProperty(this._activeScreen, eventName);
			var signal:Dynamic = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
			var eventAction:Dynamic = events[eventName];
			if(Reflect.isFunction(eventAction))
			{
				if(signal != null)
				{
					signal.remove(eventAction);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, eventAction);
				}
			}
			else if(Std.is(eventAction, String))
			{
				var eventListener:Dynamic = savedScreenEvents[eventName];
				if(signal != null)
				{
					signal.remove(eventListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, eventListener);
				}
			}
		}
		this._screenEvents[this._activeScreenID] = null;
	}

	/**
	 * @private
	 */
	private function createShowScreenEventListener(screenID:String):DisplayObject->DisplayObject->Dynamic->Void
	{
		var self:ScreenNavigator = this;
		var eventListener:Dynamic = function(event:Event):Void
		{
			self.showScreen(screenID);
		};

		return eventListener;
	}

	/**
	 * @private
	 */
	private function createShowScreenSignalListener(screenID:String, signal:Dynamic):Dynamic->Void
	{
		var self:ScreenNavigator = this;
		var signalListener:Dynamic->Void;
		if(signal.valueClasses.length == 1)
		{
			//shortcut to avoid the allocation of the rest array
			signalListener = function(arg0:Dynamic):Void
			{
				self.showScreen(screenID);
			};
		}
		else
		{
			signalListener = function(rest:Array<Dynamic>):Void
			{
				self.showScreen(screenID);
			};
		}

		return signalListener;
	}
}