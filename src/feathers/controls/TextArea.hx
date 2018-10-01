/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.text.ITextEditorViewPort;
import feathers.controls.text.TextFieldTextEditorViewPort;
import feathers.core.INativeFocusOwner;
import feathers.core.PropertyProxy;
import feathers.data.DataProperties;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import openfl.errors.ArgumentError;
import openfl.errors.RangeError;

import flash.display.InteractiveObject;
import flash.geom.Point;
import flash.ui.Mouse;
#if flash
import flash.ui.MouseCursor;
#end

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SKIN;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SELECTED;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STATE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;
import feathers.core.FeathersControl.INVALIDATION_FLAG_TEXT_EDITOR;

/**
 * Dispatched when the text area's <code>text</code> property changes.
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
 * @eventType starling.events.Event.CHANGE
 *///[Event(name="change",type="starling.events.Event")]

/**
 * A text entry control that allows users to enter and edit multiple lines
 * of uniformly-formatted text with the ability to scroll.
 *
 * <p><strong>Important:</strong> <code>TextArea</code> is not recommended
 * for mobile. Instead, you should generally use a <code>TextInput</code>
 * with a <code>StageTextTextEditor</code> that has its <code>multiline</code>
 * property set to <code>true</code> and the text input's <code>verticalAlign</code>
 * property should be set to <code>TextInput.VERTICAL_ALIGN_JUSTIFY</code>.
 * In that situation, the <code>StageText</code> instance will automatically
 * provide its own operating system native scroll bars. <code>TextArea</code>
 * is intended for use on desktop and may not behave correctly on mobile.</p>
 *
 * <p>The following example sets the text in a text area, selects the text,
 * and listens for when the text value changes:</p>
 *
 * <listing version="3.0">
 * var textArea:TextArea = new TextArea();
 * textArea.text = "Hello\nWorld"; //it's multiline!
 * textArea.selectRange( 0, textArea.text.length );
 * textArea.addEventListener( Event.CHANGE, input_changeHandler );
 * this.addChild( textArea );</listing>
 *
 * @see ../../../help/text-area.html How to use the Feathers TextArea component
 * @see feathers.controls.TextInput
 */
class TextArea extends Scroller implements INativeFocusOwner
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * The <code>TextArea</code> is enabled and does not have focus.
	 */
	inline public static var STATE_ENABLED:String = "enabled";

	/**
	 * The <code>TextArea</code> is disabled.
	 */
	inline public static var STATE_DISABLED:String = "disabled";

	/**
	 * The <code>TextArea</code> is enabled and has focus.
	 */
	inline public static var STATE_FOCUSED:String = "focused";

	/**
	 * The default <code>IStyleProvider</code> for all <code>TextArea</code>
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
		this._measureViewPort = false;
		this.addEventListener(TouchEvent.TOUCH, textArea_touchHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, textArea_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	private var textEditorViewPort:ITextEditorViewPort;

	/**
	 * @private
	 */
	private var _textEditorHasFocus:Bool = false;

	/**
	 * A text editor may be an <code>INativeFocusOwner</code>, so we need to
	 * return the value of its <code>nativeFocus</code> property. If not,
	 * then we return <code>null</code>.
	 *
	 * @see feathers.core.INativeFocusOwner
	 */
	public var nativeFocus(get, never):InteractiveObject;
	public function get_nativeFocus():InteractiveObject
	{
		if(Std.is(this.textEditorViewPort, INativeFocusOwner))
		{
			return cast(this.textEditorViewPort, INativeFocusOwner).nativeFocus;
		}
		return null;
	}

	/**
	 * @private
	 */
	private var _isWaitingToSetFocus:Bool = false;

	/**
	 * @private
	 */
	private var _pendingSelectionStartIndex:Int = -1;

	/**
	 * @private
	 */
	private var _pendingSelectionEndIndex:Int = -1;

	/**
	 * @private
	 */
	private var _textAreaTouchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _oldMouseCursor:String = null;

	/**
	 * @private
	 */
	private var _ignoreTextChanges:Bool = false;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return TextArea.globalStyleProvider;
	}

	/**
	 * @private
	 */
	override public function get_isFocusEnabled():Bool
	{
		if(this._isEditable)
		{
			//the behavior is different when editable.
			return this._isEnabled && this._isFocusEnabled;
		}
		return super.isFocusEnabled;
	}

	/**
	 * When the <code>FocusManager</code> isn't enabled, <code>hasFocus</code>
	 * can be used instead of <code>FocusManager.focus == textArea</code>
	 * to determine if the text area has focus.
	 */
	public var hasFocus(get, never):Bool;
	public function get_hasFocus():Bool
	{
		if(this._focusManager == null)
		{
			return this._textEditorHasFocus;
		}
		return this._hasFocus;
	}

	/**
	 * @private
	 */
	override public function set_isEnabled(value:Bool):Bool
	{
		super.isEnabled = value;
		if(this._isEnabled)
		{
			this.currentState = this.hasFocus ? STATE_FOCUSED : STATE_ENABLED;
		}
		else
		{
			this.currentState = STATE_DISABLED;
		}
		return get_isEnabled();
	}

	/**
	 * @private
	 */
	private var _stateNames:Array<String> = 
	[
		STATE_ENABLED, STATE_DISABLED, STATE_FOCUSED
	];

	/**
	 * A list of all valid state names for use with <code>currentState</code>.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #currentState
	 */
	private var stateNames(get, never):Array<String>;
	private function get_stateNames():Array<String>
	{
		return this._stateNames;
	}

	/**
	 * @private
	 */
	private var _currentState:String = STATE_ENABLED;

	/**
	 * The current state of the input.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentState(get, set):String;
	private function get_currentState():String
	{
		return this._currentState;
	}

	/**
	 * @private
	 */
	private function set_currentState(value:String):String
	{
		if(this._currentState == value)
		{
			return get_currentState();
		}
		if(this.stateNames.indexOf(value) < 0)
		{
			throw new ArgumentError("Invalid state: " + value + ".");
		}
		this._currentState = value;
		this.invalidate(INVALIDATION_FLAG_STATE);
		return get_currentState();
	}

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * The text displayed by the text area. The text area dispatches
	 * <code>Event.CHANGE</code> when the value of the <code>text</code>
	 * property changes for any reason.
	 *
	 * <p>In the following example, the text area's text is updated:</p>
	 *
	 * <listing version="3.0">
	 * textArea.text = "Hello World";</listing>
	 *
	 * @see #event:change
	 *
	 * @default ""
	 */
	public var text(get, set):String;
	public function get_text():String
	{
		return this._text;
	}

	/**
	 * @private
	 */
	public function set_text(value:String):String
	{
		if(value == null)
		{
			//don't allow null or undefined
			value = "";
		}
		if(this._text == value)
		{
			return get_text();
		}
		this._text = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(Event.CHANGE);
		return get_text();
	}

	/**
	 * @private
	 */
	private var _maxChars:Int = 0;

	/**
	 * The maximum number of characters that may be entered.
	 *
	 * <p>In the following example, the text area's maximum characters is
	 * specified:</p>
	 *
	 * <listing version="3.0">
	 * textArea.maxChars = 10;</listing>
	 *
	 * @default 0
	 */
	public var maxChars(get, set):Int;
	public function get_maxChars():Int
	{
		return this._maxChars;
	}

	/**
	 * @private
	 */
	public function set_maxChars(value:Int):Int
	{
		if(this._maxChars == value)
		{
			return get_maxChars();
		}
		this._maxChars = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_maxChars();
	}

	/**
	 * @private
	 */
	@:native("_restrict1")
	private var _restrict:String;

	/**
	 * Limits the set of characters that may be entered.
	 *
	 * <p>In the following example, the text area's allowed characters are
	 * restricted:</p>
	 *
	 * <listing version="3.0">
	 * textArea.restrict = "0-9;</listing>
	 *
	 * @default null
	 */
	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._restrict;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):String
	{
		if(this._restrict == value)
		{
			return get_restrict();
		}
		this._restrict = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_restrict();
	}

	/**
	 * @private
	 */
	private var _isEditable:Bool = true;

	/**
	 * Determines if the text area is editable. If the text area is not
	 * editable, it will still appear enabled.
	 *
	 * <p>In the following example, the text area is not editable:</p>
	 *
	 * <listing version="3.0">
	 * textArea.isEditable = false;</listing>
	 *
	 * @default true
	 */
	public var isEditable(get, set):Bool;
	public function get_isEditable():Bool
	{
		return this._isEditable;
	}

	/**
	 * @private
	 */
	public function set_isEditable(value:Bool):Bool
	{
		if(this._isEditable == value)
		{
			return get_isEditable();
		}
		this._isEditable = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_isEditable();
	}

	/**
	 * @private
	 */
	private var _backgroundFocusedSkin:DisplayObject;

	/**
	 * A display object displayed behind the text area's content when it
	 * has focus.
	 *
	 * <p>In the following example, the text area's focused background skin is
	 * specified:</p>
	 *
	 * <listing version="3.0">
	 * textArea.backgroundFocusedSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundFocusedSkin(get, set):DisplayObject;
	public function get_backgroundFocusedSkin():DisplayObject
	{
		return this._backgroundFocusedSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundFocusedSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundFocusedSkin == value)
		{
			return get_backgroundFocusedSkin();
		}

		if(this._backgroundFocusedSkin != null && this._backgroundFocusedSkin != this._backgroundSkin &&
			this._backgroundFocusedSkin != this._backgroundDisabledSkin)
		{
			this.removeChild(this._backgroundFocusedSkin);
		}
		this._backgroundFocusedSkin = value;
		if(this._backgroundFocusedSkin != null && this._backgroundFocusedSkin.parent != this)
		{
			this._backgroundFocusedSkin.visible = false;
			this._backgroundFocusedSkin.touchable = false;
			this.addChildAt(this._backgroundFocusedSkin, 0);
		}
		this.invalidate(INVALIDATION_FLAG_SKIN);
		return get_backgroundFocusedSkin();
	}

	/**
	 * @private
	 */
	private var _stateToSkinFunction:TextArea->Dynamic->DisplayObject->DisplayObject;

	/**
	 * Returns a skin for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function( target:TextArea, state:Dynamic, oldSkin:DisplayObject = null ):DisplayObject</pre>
	 *
	 * @default null
	 */
	public var stateToSkinFunction(get, set):TextArea->Dynamic->DisplayObject->DisplayObject;
	public function get_stateToSkinFunction():TextArea->Dynamic->DisplayObject->DisplayObject
	{
		return this._stateToSkinFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToSkinFunction(value:TextArea->Dynamic->DisplayObject->DisplayObject):TextArea->Dynamic->DisplayObject->DisplayObject
	{
		if(this._stateToSkinFunction == value)
		{
			return get_stateToSkinFunction();
		}
		this._stateToSkinFunction = value;
		this.invalidate(INVALIDATION_FLAG_SKIN);
		return get_stateToSkinFunction();
	}

	/**
	 * @private
	 */
	private var _textEditorFactory:Void->ITextEditorViewPort;

	/**
	 * A function used to instantiate the text editor view port. If
	 * <code>null</code>, a <code>TextFieldTextEditorViewPort</code> will
	 * be instantiated. The text editor must be an instance of
	 * <code>ITextEditorViewPort</code>. This factory can be used to change
	 * properties on the text editor view port when it is first created. For
	 * instance, if you are skinning Feathers components without a theme,
	 * you might use this factory to set styles on the text editor view
	 * port.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextEditorViewPort</pre>
	 *
	 * <p>In the following example, a custom text editor factory is passed
	 * to the text area:</p>
	 *
	 * <listing version="3.0">
	 * input.textEditorFactory = function():ITextEditorViewPort
	 * {
	 *     return new TextFieldTextEditorViewPort();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.text.ITextEditorViewPort
	 * @see feathers.controls.text.TextFieldTextEditorViewPort
	 */
	public var textEditorFactory(get, set):Void->ITextEditorViewPort;
	public function get_textEditorFactory():Void->ITextEditorViewPort
	{
		return this._textEditorFactory;
	}

	/**
	 * @private
	 */
	public function set_textEditorFactory(value:Void->ITextEditorViewPort):Void->ITextEditorViewPort
	{
		if(this._textEditorFactory == value)
		{
			return get_textEditorFactory();
		}
		this._textEditorFactory = value;
		this.invalidate(INVALIDATION_FLAG_TEXT_EDITOR);
		return get_textEditorFactory();
	}

	/**
	 * @private
	 */
	private var _textEditorProperties:PropertyProxy;

	/**
	 * An object that stores properties for the text area's text editor
	 * sub-component, and the properties will be passed down to the
	 * text editor when the text area validates. The available properties
	 * depend on which <code>ITextEditorViewPort</code> implementation is
	 * returned by <code>textEditorFactory</code>. Refer to
	 * <a href="text/ITextEditorViewPort.html"><code>feathers.controls.text.ITextEditorViewPort</code></a>
	 * for a list of available text editor implementations for text area.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>textEditorFactory</code> function
	 * instead of using <code>textEditorProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the text input's text editor properties
	 * are specified (this example assumes that the text editor is a
	 * <code>TextFieldTextEditorViewPort</code>):</p>
	 *
	 * <listing version="3.0">
	 * input.textEditorProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333);
	 * input.textEditorProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see #textEditorFactory
	 * @see feathers.controls.text.ITextEditorViewPort
	 */
	public var textEditorProperties(get, set):PropertyProxy;
	public function get_textEditorProperties():PropertyProxy
	{
		if(this._textEditorProperties == null)
		{
			this._textEditorProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._textEditorProperties;
	}

	/**
	 * @private
	 */
	public function set_textEditorProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._textEditorProperties == value)
		{
			return get_textEditorProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			/*for (propertyName in Reflect.fields(value))
			{
				Reflect.setProperty(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}*/
			DataProperties.copyValuesFromObjectTo(value, newValue.storage);
			value = newValue;
		}
		if(this._textEditorProperties != null)
		{
			this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._textEditorProperties = value;
		if(this._textEditorProperties != null)
		{
			this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_textEditorProperties();
	}

	/**
	 * @inheritDoc
	 */
	override public function showFocus():Void
	{
		if(this._focusManager == null || this._focusManager.focus != this)
		{
			return;
		}
		this.selectRange(0, this._text.length);
		super.showFocus();
	}

	/**
	 * Focuses the text area control so that it may be edited.
	 */
	public function setFocus():Void
	{
		if(this._textEditorHasFocus)
		{
			return;
		}
		if(this.textEditorViewPort != null)
		{
			this._isWaitingToSetFocus = false;
			this.textEditorViewPort.setFocus();
		}
		else
		{
			this._isWaitingToSetFocus = true;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
	}

	/**
	 * Manually removes focus from the text input control.
	 */
	public function clearFocus():Void
	{
		this._isWaitingToSetFocus = false;
		if(this.textEditorViewPort == null || !this._textEditorHasFocus)
		{
			return;
		}
		this.textEditorViewPort.clearFocus();
	}

	/**
	 * Sets the range of selected characters. If both values are the same,
	 * or the end index is <code>-1</code>, the text insertion position is
	 * changed and nothing is selected.
	 */
	public function selectRange(startIndex:Int, endIndex:Int = -1):Void
	{
		if(endIndex < 0)
		{
			endIndex = startIndex;
		}
		if(startIndex < 0)
		{
			throw new ArgumentError("Expected start index greater than or equal to 0. Received " + startIndex + ".");
		}
		if(endIndex > this._text.length)
		{
			throw new RangeError("Expected start index less than " + this._text.length + ". Received " + endIndex + ".");
		}

		if(this.textEditorViewPort != null)
		{
			this._pendingSelectionStartIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.textEditorViewPort.selectRange(startIndex, endIndex);
		}
		else
		{
			this._pendingSelectionStartIndex = startIndex;
			this._pendingSelectionEndIndex = endIndex;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var textEditorInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);

		if(textEditorInvalid)
		{
			this.createTextEditor();
		}

		if(textEditorInvalid || stylesInvalid)
		{
			this.refreshTextEditorProperties();
		}

		if(textEditorInvalid || dataInvalid)
		{
			var oldIgnoreTextChanges:Bool = this._ignoreTextChanges;
			this._ignoreTextChanges = true;
			this.textEditorViewPort.text = this._text;
			this._ignoreTextChanges = oldIgnoreTextChanges;
		}

		if(textEditorInvalid || stateInvalid)
		{
			this.textEditorViewPort.isEnabled = this._isEnabled;
			#if flash
			if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor != null)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
			#end
		}

		super.draw();

		this.doPendingActions();
	}

	/**
	 * Creates and adds the <code>textEditorViewPort</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #textEditorViewPort
	 * @see #textEditorFactory
	 */
	private function createTextEditor():Void
	{
		if(this.textEditorViewPort != null)
		{
			this.textEditorViewPort.removeEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
			this.textEditorViewPort = null;
		}

		if(this._textEditorFactory != null)
		{
			this.textEditorViewPort = this._textEditorFactory();
		}
		else
		{
			this.textEditorViewPort = new TextFieldTextEditorViewPort();
		}
		this.textEditorViewPort.addEventListener(Event.CHANGE, textEditor_changeHandler);
		this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
		this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);

		var oldViewPort:ITextEditorViewPort = cast(this._viewPort, ITextEditorViewPort);
		this.viewPort = this.textEditorViewPort;
		if(oldViewPort != null)
		{
			//the view port setter won't do this
			oldViewPort.dispose();
		}
	}

	/**
	 * @private
	 */
	private function doPendingActions():Void
	{
		if(this._isWaitingToSetFocus || (this._focusManager != null && this._focusManager.focus == this))
		{
			this._isWaitingToSetFocus = false;
			if(!this._textEditorHasFocus)
			{
				this.textEditorViewPort.setFocus();
			}
		}
		if(this._pendingSelectionStartIndex >= 0)
		{
			var startIndex:Int = this._pendingSelectionStartIndex;
			var endIndex:Int = this._pendingSelectionEndIndex;
			this._pendingSelectionStartIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.selectRange(startIndex, endIndex);
		}
	}

	/**
	 * @private
	 */
	private function refreshTextEditorProperties():Void
	{
		this.textEditorViewPort.maxChars = this._maxChars;
		this.textEditorViewPort.restrict = this._restrict;
		this.textEditorViewPort.isEditable = this._isEditable;
		/*for (propertyName in Reflect.fields(this._textEditorProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._textEditorProperties.storage, propertyName);
			Reflect.setProperty(this.textEditorViewPort, propertyName, propertyValue);
		}*/
		DataProperties.copyValuesFromDictionaryTo(_textEditorProperties.storage,textEditorViewPort);
	}

	/**
	 * @private
	 */
	override private function refreshBackgroundSkin():Void
	{
		var oldSkin:DisplayObject = this.currentBackgroundSkin;
		if(this._stateToSkinFunction != null)
		{
			this.currentBackgroundSkin = this._stateToSkinFunction(this, this._currentState, oldSkin);
		}
		else if(!this._isEnabled && this._backgroundDisabledSkin != null)
		{
			this.currentBackgroundSkin = this._backgroundDisabledSkin;
		}
		else if(this.hasFocus && this._backgroundFocusedSkin != null)
		{
			this.currentBackgroundSkin = this._backgroundFocusedSkin;
		}
		else
		{
			this.currentBackgroundSkin = this._backgroundSkin;
		}
		if(oldSkin != this.currentBackgroundSkin)
		{
			if(oldSkin != null)
			{
				this.removeChild(oldSkin, false);
			}
			if(this.currentBackgroundSkin != null)
			{
				this.addChildAt(this.currentBackgroundSkin, 0);
				if(this.originalBackgroundWidth != this.originalBackgroundWidth) //isNaN
				{
					this.originalBackgroundWidth = this.currentBackgroundSkin.width;
				}
				if(this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
				{
					this.originalBackgroundHeight = this.currentBackgroundSkin.height;
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function setFocusOnTextEditorWithTouch(touch:Touch):Void
	{
		if(!this.isFocusEnabled)
		{
			return;
		}
		touch.getLocation(this.stage, HELPER_POINT);
		var isInBounds:Bool = this.contains(this.stage.hitTest(HELPER_POINT, true));
		if(!this._textEditorHasFocus && isInBounds)
		{
			this.globalToLocal(HELPER_POINT, HELPER_POINT);
			HELPER_POINT.x -= this._paddingLeft;
			HELPER_POINT.y -= this._paddingTop;
			this._isWaitingToSetFocus = false;
			this.textEditorViewPort.setFocus(HELPER_POINT);
		}
	}

	/**
	 * @private
	 */
	private function textArea_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._textAreaTouchPointID = -1;
			return;
		}

		var horizontalScrollBar:DisplayObject = cast(this.horizontalScrollBar, DisplayObject);
		var verticalScrollBar:DisplayObject = cast(this.verticalScrollBar, DisplayObject);
		var touch:Touch;
		if(this._textAreaTouchPointID >= 0)
		{
			touch = event.getTouch(this, TouchPhase.ENDED, this._textAreaTouchPointID);
			if(touch == null || touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
			{
				return;
			}
			this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
			this._textAreaTouchPointID = -1;
			if(this.textEditorViewPort.setTouchFocusOnEndedPhase)
			{
				this.setFocusOnTextEditorWithTouch(touch);
			}
		}
		else
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch != null)
			{
				if(touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
				{
					return;
				}
				this._textAreaTouchPointID = touch.id;
				if(!this.textEditorViewPort.setTouchFocusOnEndedPhase)
				{
					this.setFocusOnTextEditorWithTouch(touch);
				}
				this.addEventListener(Event.SCROLL, textArea_scrollHandler);
				return;
			}
			touch = event.getTouch(this, TouchPhase.HOVER);
			if(touch != null)
			{
				if(touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
				{
					return;
				}
				#if flash
				if(Mouse.supportsNativeCursor && this._oldMouseCursor == null)
				{
					this._oldMouseCursor = Mouse.cursor;
					Mouse.cursor = MouseCursor.IBEAM;
				}
				#end
				return;
			}
			//end hover
			#if flash
			if(Mouse.supportsNativeCursor && this._oldMouseCursor != null)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
			#end
		}
	}

	/**
	 * @private
	 */
	private function textArea_scrollHandler(event:Event):Void
	{
		this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
		this._textAreaTouchPointID = -1;
	}

	/**
	 * @private
	 */
	private function textArea_removedFromStageHandler(event:Event):Void
	{
		if(this._focusManager == null && this._textEditorHasFocus)
		{
			this.clearFocus();
		}
		this._isWaitingToSetFocus = false;
		this._textEditorHasFocus = false;
		this._textAreaTouchPointID = -1;
		this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
		#if flash
		if(Mouse.supportsNativeCursor && this._oldMouseCursor != null)
		{
			Mouse.cursor = this._oldMouseCursor;
			this._oldMouseCursor = null;
		}
		#end
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		if(this._focusManager == null)
		{
			return;
		}
		super.focusInHandler(event);
		this.setFocus();
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		if(this._focusManager == null)
		{
			return;
		}
		super.focusOutHandler(event);
		this.textEditorViewPort.clearFocus();
		this.invalidate(INVALIDATION_FLAG_STATE);
	}

	/**
	 * @private
	 */
	override private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(this._isEditable)
		{
			return;
		}
		super.stage_keyDownHandler(event);
	}

	/**
	 * @private
	 */
	private function textEditor_changeHandler(event:Event):Void
	{
		if(this._ignoreTextChanges)
		{
			return;
		}
		this.text = this.textEditorViewPort.text;
	}

	/**
	 * @private
	 */
	private function textEditor_focusInHandler(event:Event):Void
	{
		this._textEditorHasFocus = true;
		this.currentState = STATE_FOCUSED;
		this._touchPointID = -1;
		this.invalidate(INVALIDATION_FLAG_STATE);
		if(this._focusManager != null && this.isFocusEnabled && this._focusManager.focus != this)
		{
			//if setFocus() was called manually, we need to notify the focus
			//manager (unless isFocusEnabled is false).
			//if the focus manager already knows that we have focus, it will
			//simply return without doing anything.
			this._focusManager.focus = this;
		}
		else if(this._focusManager == null)
		{
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}
	}

	/**
	 * @private
	 */
	private function textEditor_focusOutHandler(event:Event):Void
	{
		this._textEditorHasFocus = false;
		this.currentState = this._isEnabled ? STATE_ENABLED : STATE_DISABLED;
		this.invalidate(INVALIDATION_FLAG_STATE);
		if(this._focusManager != null && this._focusManager.focus == this)
		{
			//if clearFocus() was called manually, we need to notify the
			//focus manager if it still thinks we have focus.
			this._focusManager.focus = null;
		}
		else if(this._focusManager == null)
		{
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
	}
}
