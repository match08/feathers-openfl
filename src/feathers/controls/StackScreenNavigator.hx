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

import starling.display.DisplayObject;
import starling.events.Event;

import openfl.errors.ArgumentError;
import openfl.errors.TypeError;

/**
 * A "view stack"-like container that supports navigation between screens
 * (any display object) through events.
 *
 * <p>The following example creates a screen navigator, adds a screen and
 * displays it:</p>
 *
 * <listing version="3.0">
 * var navigator:StackScreenNavigator = new StackScreenNavigator();
 * navigator.addScreen( "mainMenu", new StackScreenNavigatorItem( MainMenuScreen ) );
 * this.addChild( navigator );
 * 
 * navigator.rootScreenID = "mainMenu";</listing>
 *
 * @see ../../../help/stack-screen-navigator.html How to use the Feathers StackScreenNavigator component
 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
 * @see feathers.controls.StackScreenNavigatorItem
 */
class StackScreenNavigator extends BaseScreenNavigator
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
	 * The default <code>IStyleProvider</code> for all <code>StackScreenNavigator</code>
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
		this.addEventListener(FeathersEventType.INITIALIZE, stackScreenNavigator_initializeHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return StackScreenNavigator.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _pushTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function that is called when the screen navigator pushes a new
	 * screen onto the stack. 
	 *
	 * <p>In the following example, the screen navigator is given a push
	 * transition that slides the screens to the left:</p>
	 *
	 * <listing version="3.0">
	 * navigator.pushTransition = Slide.createSlideLeftTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
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
	 * @see #pushScreen()
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var pushTransition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_pushTransition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._pushTransition;
	}

	/**
	 * @private
	 */
	public function set_pushTransition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		if(this._pushTransition == value)
		{
			return get_pushTransition();
		}
		this._pushTransition = value;
		return get_pushTransition();
	}

	/**
	 * @private
	 */
	private var _popTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function that is called when the screen navigator pops a screen
	 * from the top of the stack.
	 *
	 * <p>In the following example, the screen navigator is given a pop
	 * transition that slides the screens to the right:</p>
	 *
	 * <listing version="3.0">
	 * navigator.popTransition = Slide.createSlideRightTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
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
	 * @see #popScreen()
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var popTransition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_popTransition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._popTransition;
	}

	/**
	 * @private
	 */
	public function set_popTransition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		if(this._popTransition == value)
		{
			return get_popTransition();
		}
		this._popTransition = value;
		return get_popTransition();
	}

	/**
	 * @private
	 */
	private var _popToRootTransition:DisplayObject->DisplayObject->Dynamic->Void = null;

	/**
	 * Typically used to provide some kind of animation or visual effect, a
	 * function that is called when the screen navigator clears its stack,
	 * to show the first screen that was pushed onto the stack.
	 *
	 * <p>If this property is <code>null</code>, the value of the
	 * <code>popTransition</code> property will be used instead.</p>
	 *
	 * <p>In the following example, a custom pop to root transition is
	 * passed to the screen navigator:</p>
	 *
	 * <listing version="3.0">
	 * navigator.popToRootTransition = Fade.createFadeInTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
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
	 * @see #popTransition
	 * @see #popToRootScreen()
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var popToRootTransition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_popToRootTransition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._popToRootTransition;
	}

	/**
	 * @private
	 */
	public function set_popToRootTransition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		if(this._popToRootTransition == value)
		{
			return get_popToRootTransition();
		}
		this._popToRootTransition = value;
		return get_popToRootTransition();
	}

	/**
	 * @private
	 */
	private var _stack:Array<StackItem> = new Array<StackItem>();

	/**
	 * @private
	 */
	private var _pushScreenEvents:Dynamic = {};

	/**
	 * @private
	 */
	private var _popScreenEvents:Array<String>;

	/**
	 * @private
	 */
	private var _popToRootScreenEvents:Array<String>;

	/**
	 * @private
	 */
	private var _tempRootScreenID:String;

	/**
	 * Sets the first screen at the bottom of the stack, or the root screen.
	 * When this screen is shown, there will be no transition.
	 *
	 * <p>If the stack contains screens when you set this property, they
	 * will be removed from the stack. In other words, setting this property
	 * will clear the stack, erasing the current history.</p>
	 *
	 * <p>In the following example, the root screen is set:</p>
	 *
	 * <listing version="3.0">
	 * navigator.rootScreenID = "someScreen";</listing>
	 *
	 * @see #popToRootScreen()
	 */
	public var rootScreenID(get, set):String;
	public function get_rootScreenID():String
	{
		if(this._tempRootScreenID != null)
		{
			return this._tempRootScreenID;
		}
		else if(this._stack.length == 0)
		{
			return this._activeScreenID;
		}
		return this._stack[0].id;
	}

	/**
	 * @private
	 */
	public function set_rootScreenID(value:String):String
	{
		if(this._isInitialized)
		{
			//we may have delayed showing the root screen until after
			//initialization, but this property could be set between when
			//_isInitialized is set to true and when the screen is actually
			//shown, so we need to clear this variable, just in case. 
			this._tempRootScreenID = null;
			
			//this clears the whole stack and starts fresh
			this._stack.splice(0, this._stack.length);
			if(value != null)
			{
				//show without a transition because we're not navigating.
				//we're forcibly replacing the root screen.
				this.showScreenInternal(value, null);
			}
			else
			{
				this.clearScreenInternal(null);
			}
		}
		else
		{
			this._tempRootScreenID = value;
		}
		return get_rootScreenID();
	}

	/**
	 * Registers a new screen with a string identifier that can be used
	 * to reference the screen in other calls, like <code>removeScreen()</code>
	 * or <code>pushScreen()</code>.
	 *
	 * @see #removeScreen()
	 */
	public function addScreen(id:String, item:StackScreenNavigatorItem):Void
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
	public function removeScreen(id:String):StackScreenNavigatorItem
	{
		var stackCount:Int = this._stack.length;
		//for(var i:Int = stackCount - 1; i >= 0; i--)
		var i:Int = stackCount - 1;
		while(i >= 0)
		{
			var item:StackItem = this._stack[i];
			if(item.id == id)
			{
				this._stack.splice(i, 1);
			}
			
			i--;
		}
		return cast(this.removeScreenInternal(id), StackScreenNavigatorItem);
	}

	/**
	 * @private
	 */
	override public function removeAllScreens():Void
	{
		this._stack.splice(0, this._stack.length);
		super.removeAllScreens();
	}

	/**
	 * Returns the <code>StackScreenNavigatorItem</code> instance with the
	 * specified identifier.
	 */
	public function getScreen(id:String):StackScreenNavigatorItem
	{
		return cast(this._screens[id], StackScreenNavigatorItem);
	}

	/**
	 * Pushes a screen onto the top of the stack.
	 *
	 * <p>A set of key-value pairs representing properties on the previous
	 * screen may be passed in. If the new screen is popped, these values
	 * may be used to restore the previous screen's state.</p>
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>pushTransition</code> property will be used instead.</p>
	 *
	 * <p>Returns a reference to the new screen, unless a transition is
	 * currently active. In that case, the new screen will be queued until
	 * the transition has completed, and no reference will be returned.</p>
	 *
	 * @see #pushTransition
	 */
	public function pushScreen(id:String, savedPreviousScreenProperties:Dynamic = null, transition:DisplayObject->DisplayObject->Dynamic->Void = null):DisplayObject
	{
		if(transition == null)
		{
			var item:StackScreenNavigatorItem = this.getScreen(id);
			if(item != null && item.pushTransition != null)
			{
				transition = item.pushTransition;
			}
			else
			{
				transition = this.pushTransition;
			}
		}
		if(this._activeScreenID != null)
		{
			this._stack[this._stack.length] = new StackItem(this._activeScreenID, savedPreviousScreenProperties);
		}
		else if(savedPreviousScreenProperties)
		{
			throw new ArgumentError("Cannot save properties for the previous screen because there is no previous screen.");
		}
		return this.showScreenInternal(id, transition);
	}

	/**
	 * Pops the current screen from the top of the stack, returning to the
	 * previous screen.
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>popTransition</code> property will be used instead.</p>
	 *
	 * <p>Returns a reference to the new screen, unless a transition is
	 * currently active. In that case, the new screen will be queued until
	 * the transition has completed, and no reference will be returned.</p>
	 *
	 * @see #popTransition
	 */
	public function popScreen(transition:DisplayObject->DisplayObject->Dynamic->Void = null):DisplayObject
	{
		if(this._stack.length == 0)
		{
			return this._activeScreen;
		}
		if(transition == null)
		{
			var screenItem:StackScreenNavigatorItem = this.getScreen(this._activeScreenID);
			if(screenItem != null && screenItem.popTransition != null)
			{
				transition = screenItem.popTransition;
			}
			else
			{
				transition = this.popTransition;
			}
		}
		var stackItem:StackItem = this._stack.pop();
		return this.showScreenInternal(stackItem.id, transition, stackItem.properties);
	}

	/**
	 * Returns to the root screen, at the bottom of the stack.
	 *
	 * <p>An optional transition may be specified. If <code>null</code>, the
	 * <code>popToRootTransition</code> or <code>popTransition</code>
	 * property will be used instead.</p>
	 *
	 * <p>Returns a reference to the new screen, unless a transition is
	 * currently active. In that case, the new screen will be queued until
	 * the transition has completed, and no reference will be returned.</p>
	 *
	 * @see #popToRootTransition
	 * @see #popTransition
	 */
	public function popToRootScreen(transition:DisplayObject->DisplayObject->Dynamic->Void = null):DisplayObject
	{
		if(this._stack.length == 0)
		{
			return this._activeScreen;
		}
		if(transition == null)
		{
			transition = this.popToRootTransition;
			if(transition == null)
			{
				transition = this.popTransition;
			}
		}
		var item:StackItem = this._stack[0];
		this._stack.splice(0, this._stack.length);
		return this.showScreenInternal(item.id, transition, item.properties);
	}

	/**
	 * @private
	 */
	override private function prepareActiveScreen():Void
	{
		var item:StackScreenNavigatorItem = cast(this._screens[this._activeScreenID], StackScreenNavigatorItem);
		var events:Dynamic = item.pushEvents;
		var savedScreenEvents:Dynamic = { };
		var signal:Dynamic;
		for(eventName in Reflect.fields(events))
		{
			var prop = Reflect.getProperty(this._activeScreen, eventName);
			signal = prop/*prop != null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
			var eventAction:Dynamic = Reflect.field(events, eventName);
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
					eventListener = this.createPushScreenSignalListener(cast(eventAction, String), signal);
					signal.add(eventListener);
				}
				else
				{
					eventListener = this.createPushScreenEventListener(cast(eventAction, String));
					this._activeScreen.addEventListener(eventName, eventListener);
				}
				Reflect.setProperty(savedScreenEvents, eventName, eventListener);
			}
			else
			{
				throw new TypeError("Unknown event action defined for screen:" + eventAction.toString());
			}
		}
		Reflect.setProperty(this._pushScreenEvents, this._activeScreenID, savedScreenEvents);
		var eventCount:Int;
		var popEvents:Array<String> = null;
		if(item.popEvents != null)
		{
			//creating a copy because this array could change before the screen
			//is removed.
			popEvents = item.popEvents.copy();
			eventCount = popEvents.length;
			//for(var i:Int = 0; i < eventCount; i++)
			for(i in 0 ... eventCount)
			{
				var eventName:String = popEvents[i];
				var prop = Reflect.getProperty(this._activeScreen, eventName);
				signal = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
				if(signal != null)
				{
					signal.add(popSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = popEvents;
		}
		if(item.popToRootEvents != null)
		{
			//creating a copy because this array could change before the screen
			//is removed.
			var popToRootEvents:Array<String> = item.popToRootEvents.copy();
			eventCount = popToRootEvents.length;
			//for(i = 0; i < eventCount; i++)
			for(i in 0 ... eventCount)
			{
				var eventName:String = popToRootEvents[i];
				var prop = Reflect.getProperty(this._activeScreen, eventName);
				signal = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
				if(signal != null)
				{
					signal.add(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = popEvents;
		}
	}

	/**
	 * @private
	 */
	override private function cleanupActiveScreen():Void
	{
		var item:StackScreenNavigatorItem = cast(this._screens[this._activeScreenID], StackScreenNavigatorItem);
		var pushEvents:Dynamic = item.pushEvents;
		var savedScreenEvents:Dynamic = Reflect.field(this._pushScreenEvents, this._activeScreenID);
		var signal:Dynamic;
		for(eventName in Reflect.fields(pushEvents))
		{
			var prop = Reflect.getProperty(this._activeScreen, eventName);
			signal = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
			var eventAction:Dynamic = Reflect.field(pushEvents, eventName);
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
				var eventListener:Dynamic = Reflect.field(savedScreenEvents, eventName);
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
		Reflect.setProperty(this._pushScreenEvents, this._activeScreenID, null);
		var eventCount:Int;
		if(this._popScreenEvents != null)
		{
			eventCount = this._popScreenEvents.length;
			//for(var i:Int = 0; i < eventCount; i++)
			for(i in 0 ... eventCount)
			{
				var eventName:String = this._popScreenEvents[i];
				var prop = Reflect.getProperty(this._activeScreen, eventName);
				signal = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
				if(signal != null)
				{
					signal.remove(popSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = null;
		}
		if(this._popToRootScreenEvents != null)
		{
			eventCount = this._popToRootScreenEvents.length;
			//for(i = 0; i < eventCount; i++)
			for(i in 0 ... eventCount)
			{
				var eventName:String = this._popToRootScreenEvents[i];
				var prop = Reflect.getProperty(this._activeScreen, eventName);
				signal = prop /*!= null ? cast(prop, BaseScreenNavigator.SIGNAL_TYPE) : null*/;
				if(signal != null)
				{
					signal.remove(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = null;
		}
	}

	/**
	 * @private
	 */
	private function createPushScreenEventListener(screenID:String):Event->Dynamic->Void
	{
		var self:StackScreenNavigator = this;
		var eventListener:Event->Dynamic->Void = function(event:Event, data:Dynamic):Void
		{
			self.pushScreen(screenID, data);
		};

		return eventListener;
	}

	/**
	 * @private
	 */
	private function createPushScreenSignalListener(screenID:String, signal:Dynamic):Array<Dynamic>->Void
	{
		var self:StackScreenNavigator = this;
		var signalListener:Array<Dynamic>->Void;
		if(signal.valueClasses.length == 1)
		{
			//shortcut to avoid the allocation of the rest array
			signalListener = function(arg0:Dynamic):Void
			{
				self.pushScreen(screenID, arg0);
			};
		}
		else
		{
			signalListener = function(rest:Array<Dynamic>):Void
			{
				var data:Dynamic = null;
				if(rest.length > 0)
				{
					data = rest[0];
				}
				self.pushScreen(screenID, data);
			};
		}

		return signalListener;
	}

	/**
	 * @private
	 */
	private function popEventListener(event:Event):Void
	{
		this.popScreen();
	}

	/**
	 * @private
	 */
	private function popSignalListener(rest:Array<Dynamic>):Void
	{
		this.popScreen();
	}

	/**
	 * @private
	 */
	private function popToRootEventListener(event:Event):Void
	{
		this.popToRootScreen();
	}

	/**
	 * @private
	 */
	private function popToRootSignalListener(rest:Array<Dynamic>):Void
	{
		this.popToRootScreen();
	}

	/**
	 * @private
	 */
	private function stackScreenNavigator_initializeHandler(event:Event):Void
	{
		if(this._tempRootScreenID != null)
		{
			var screenID:String = this._tempRootScreenID;
			this._tempRootScreenID = null;
			this.showScreenInternal(screenID, null);
		}
	}
}

@:final class StackItem
{
	public function new(id:String, properties:Dynamic)
	{
		this.id = id;
		this.properties = properties;
	}

	public var id:String;
	public var properties:Dynamic;
}
