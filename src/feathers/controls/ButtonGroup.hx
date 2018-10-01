/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import com.jaimedominguez.dataType.Boolean;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.DataProperties;
import feathers.data.ListCollection;
import feathers.layout.HorizontalLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.VerticalLayout;
import feathers.layout.ViewPortBounds;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Dispatched when one of the buttons is triggered. The <code>data</code>
 * property of the event contains the item from the data provider that is
 * associated with the button that was triggered.
 *
 * <p>The following example listens to <code>Event.TRIGGERED</code> on the
 * button group instead of on individual buttons:</p>
 *
 * <listing version="3.0">
 * group.dataProvider = new ListCollection(
 * [
 *     { label: "Yes" },
 *     { label: "No" },
 *     { label: "Cancel" },
 * ]);
 * group.addEventListener( Event.TRIGGERED, function( event:Event, data:Dynamic ):Void
 * {
 *    trace( "The button with label \"" + data.label + "\" was triggered." );
 * }</listing>
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The item associated with the button
 *   that was triggered.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.TRIGGERED
 */
//[Event(name="triggered", type="starling.events.Event")]

/**
 * A set of related buttons with layout, customized using a data provider.
 *
 * <p>The following example creates a button group with a few buttons:</p>
 *
 * <listing version="3.0">
 * var group:ButtonGroup = new ButtonGroup();
 * group.dataProvider = new ListCollection(
 * [
 *     { label: "Yes", triggered: yesButton_triggeredHandler },
 *     { label: "No", triggered: noButton_triggeredHandler },
 *     { label: "Cancel", triggered: cancelButton_triggeredHandler },
 * ]);
 * this.addChild( group );</listing>
 *
 * @see ../../../help/button-group.html How to use the Feathers ButtonGroup component
 * @see feathers.controls.TabBar
 */
class ButtonGroup extends FeathersControl
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>ButtonGroup</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

	/**
	 * @private
	 */
	inline private static var LABEL_FIELD:String = "label";

	/**
	 * @private
	 */
	inline private static var ENABLED_FIELD:String = "isEnabled";

	/**
	 * @private
	 */
	private static var DEFAULT_BUTTON_FIELDS:Array<String> = 
	[
		"defaultIcon",
		"upIcon",
		"downIcon",
		"hoverIcon",
		"disabledIcon",
		"defaultSelectedIcon",
		"selectedUpIcon",
		"selectedDownIcon",
		"selectedHoverIcon",
		"selectedDisabledIcon",
		"isSelected",
		"isToggle",
	];

	/**
	 * @private
	 */
	private static var DEFAULT_BUTTON_EVENTS:Array<String> = 
	[
		Event.TRIGGERED,
		Event.CHANGE,
	];

	/**
	 * The buttons are displayed in order from left to right.
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The buttons are displayed in order from top to bottom.
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The buttons will be aligned horizontally to the left edge of the
	 * button group.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * The buttons will be aligned horizontally to the center of the
	 * button group.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * The buttons will be aligned horizontally to the right edge of the
	 * button group.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * If the direction is vertical, each button will fill the entire
	 * width of the button group, and if the direction is horizontal, the
	 * alignment will behave the same as <code>HORIZONTAL_ALIGN_LEFT</code>.
	 *
	 * @see #horizontalAlign
	 * @see #direction
	 */
	inline public static var HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The buttons will be aligned vertically to the top edge of the
	 * button group.
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The buttons will be aligned vertically to the middle of the
	 * button group.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The buttons will be aligned vertically to the bottom edge of the
	 * button group.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * If the direction is horizontal, each button will fill the entire
	 * height of the button group, and if the direction is vertical, the
	 * alignment will behave the same as <code>VERTICAL_ALIGN_TOP</code>.
	 *
	 * @see #verticalAlign
	 * @see #direction
	 */
	inline public static var VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The default value added to the <code>styleNameList</code> of the buttons.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-button-group-button";

	/**
	 * DEPRECATED: Replaced by <code>ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ButtonGroup#DEFAULT_CHILD_STYLE_NAME_BUTTON
	 */
	inline public static var DEFAULT_CHILD_NAME_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * @private
	 */
	private static function defaultButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		_buttonInitializer = defaultButtonInitializer;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the buttons.
	 * This variable is <code>protected</code> so that sub-classes can
	 * customize the button style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
	 *
	 * <p>To customize the button style name without subclassing, see
	 * <code>customButtonStyleName</code>.</p>
	 *
	 * @see #customButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var buttonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>buttonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #buttonStyleName
	 */
	public var buttonName(get, set):String;
	private function get_buttonName():String
	{
		return this.buttonStyleName;
	}

	/**
	 * @private
	 */
	private function set_buttonName(value:String):String
	{
		this.buttonStyleName = value;
		return get_buttonName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the first button.
	 *
	 * <p>To customize the first button name without subclassing, see
	 * <code>customFirstButtonStyleName</code>.</p>
	 *
	 * @see #customFirstButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var firstButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>firstButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #firstButtonStyleName
	 */
	private var firstButtonName(get, set):String;
	private function get_firstButtonName():String
	{
		return this.firstButtonStyleName;
	}

	/**
	 * @private
	 */
	private function set_firstButtonName(value:String):String
	{
		this.firstButtonStyleName = value;
		return get_firstButtonName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the last button.
	 *
	 * <p>To customize the last button style name without subclassing, see
	 * <code>customLastButtonStyleName</code>.</p>
	 *
	 * @see #customLastButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var lastButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>lastButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #lastButtonStyleName
	 */
	private var lastButtonName(get, set):String;
	private function get_lastButtonName():String
	{
		return this.lastButtonStyleName;
	}

	/**
	 * @private
	 */
	private function set_lastButtonName(value:String):String
	{
		this.lastButtonStyleName = value;
		return get_lastButtonName();
	}

	/**
	 * @private
	 */
	private var activeFirstButton:Button;

	/**
	 * @private
	 */
	private var inactiveFirstButton:Button;

	/**
	 * @private
	 */
	private var activeLastButton:Button;

	/**
	 * @private
	 */
	private var inactiveLastButton:Button;

	/**
	 * @private
	 */
	private var _layoutItems:Array<DisplayObject> = new Array();

	/**
	 * @private
	 */
	private var activeButtons:Array<Button> = new Array();

	/**
	 * @private
	 */
	private var inactiveButtons:Array<Button> = new Array();

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ButtonGroup.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;

	/**
	 * The collection of data to be displayed with buttons.
	 *
	 * <p>The following example sets the button group's data provider:</p>
	 *
	 * <listing version="3.0">
	 * group.dataProvider = new ListCollection(
	 * [
	 *     { label: "Yes", triggered: yesButton_triggeredHandler },
	 *     { label: "No", triggered: noButton_triggeredHandler },
	 *     { label: "Cancel", triggered: cancelButton_triggeredHandler },
	 * ]);</listing>
	 *
	 * <p>By default, items in the data provider support the following
	 * properties from <code>Button</code></p>
	 *
	 * <ul>
	 *     <li>label</li>
	 *     <li>defaultIcon</li>
	 *     <li>upIcon</li>
	 *     <li>downIcon</li>
	 *     <li>hoverIcon</li>
	 *     <li>disabledIcon</li>
	 *     <li>defaultSelectedIcon</li>
	 *     <li>selectedUpIcon</li>
	 *     <li>selectedDownIcon</li>
	 *     <li>selectedHoverIcon</li>
	 *     <li>selectedDisabledIcon</li>
	 *     <li>isSelected (only supported by <code>ToggleButton</code>)</li>
	 *     <li>isToggle (only supported by <code>ToggleButton</code>)</li>
	 *     <li>isEnabled</li>
	 * </ul>
	 *
	 * <p>Additionally, you can add the following event listeners:</p>
	 *
	 * <ul>
	 *     <li>Event.TRIGGERED</li>
	 *     <li>Event.CHANGE (only supported by <code>ToggleButton</code>)</li>
	 * </ul>
	 *
	 * <p>To use properties and events that are only supported by
	 * <code>ToggleButton</code>, you must provide a <code>buttonFactory</code>
	 * that returns a <code>ToggleButton</code> instead of a <code>Button</code>.</p>
	 *
	 * <p>You can pass a function to the <code>buttonInitializer</code>
	 * property that can provide custom logic to interpret each item in the
	 * data provider differently.</p>
	 *
	 * @default null
	 *
	 * @see Button
	 * @see #buttonInitializer
	 */
	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}

	/**
	 * @private
	 */
	public function set_dataProvider(value:ListCollection):ListCollection
	{
		if(this._dataProvider == value)
		{
			return get_dataProvider();
		}
		if(this._dataProvider != null)
		{
			this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider != null)
		{
			this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_dataProvider();
	}

	/**
	 * @private
	 */
	private var verticalLayout:VerticalLayout;

	/**
	 * @private
	 */
	private var horizontalLayout:HorizontalLayout;

	/**
	 * @private
	 */
	private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

	/**
	 * @private
	 */
	private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

	/**
	 * @private
	 */
	private var _direction:String = DIRECTION_VERTICAL;

	//[Inspectable(type="String",enumeration="horizontal,vertical")]
	/**
	 * The button group layout is either vertical or horizontal.
	 *
	 * <p>The following example sets the layout direction of the buttons
	 * to line them up horizontally:</p>
	 *
	 * <listing version="3.0">
	 * group.direction = ButtonGroup.DIRECTION_HORIZONTAL;</listing>
	 *
	 * @default ButtonGroup.DIRECTION_VERTICAL
	 *
	 * @see #DIRECTION_HORIZONTAL
	 * @see #DIRECTION_VERTICAL
	 */
	public var direction(get, set):String;
	public function get_direction():String
	{
		return _direction;
	}

	/**
	 * @private
	 */
	public function set_direction(value:String):String
	{
		if(this._direction == value)
		{
			return get_direction();
		}
		this._direction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_direction();
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_JUSTIFY;

	//[Inspectable(type="String",enumeration="left,center,right,justify")]
	/**
	 * Determines how the buttons are horizontally aligned within the bounds
	 * of the button group (on the x-axis).
	 *
	 * <p>The following example aligns the group's content to the left:</p>
	 *
	 * <listing version="3.0">
	 * group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_LEFT;</listing>
	 *
	 * @default ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 * @see #HORIZONTAL_ALIGN_JUSTIFY
	 */
	public var horizontalAlign(get, set):String;
	public function get_horizontalAlign():String
	{
		return this._horizontalAlign;
	}

	/**
	 * @private
	 */
	public function set_horizontalAlign(value:String):String
	{
		if(this._horizontalAlign == value)
		{
			return get_horizontalAlign();
		}
		this._horizontalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_horizontalAlign();
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_JUSTIFY;

	//[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	/**
	 * Determines how the buttons are vertically aligned within the bounds
	 * of the button group (on the y-axis).
	 *
	 * <p>The following example aligns the group's content to the top:</p>
	 *
	 * <listing version="3.0">
	 * group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_TOP;</listing>
	 *
	 * @default ButtonGroup.VERTICAL_ALIGN_JUSTIFY
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #VERTICAL_ALIGN_JUSTIFY
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return _verticalAlign;
	}

	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return get_verticalAlign();
		}
		this._verticalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalAlign();
	}

	/**
	 * @private
	 */
	private var _distributeButtonSizes:Bool = true;

	/**
	 * If <code>true</code>, the buttons will be equally sized in the
	 * direction of the layout. In other words, if the button group is
	 * horizontal, each button will have the same width, and if the button
	 * group is vertical, each button will have the same height. If
	 * <code>false</code>, the buttons will be sized to their ideal
	 * dimensions.
	 *
	 * <p>The following example doesn't distribute the button sizes:</p>
	 *
	 * <listing version="3.0">
	 * group.distributeButtonSizes = false;</listing>
	 *
	 * @default true
	 */
	public var distributeButtonSizes(get, set):Bool;
	public function get_distributeButtonSizes():Bool
	{
		return this._distributeButtonSizes;
	}

	/**
	 * @private
	 */
	public function set_distributeButtonSizes(value:Bool):Bool
	{
		if(this._distributeButtonSizes == value)
		{
			return get_distributeButtonSizes();
		}
		this._distributeButtonSizes = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_distributeButtonSizes();
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * Space, in pixels, between buttons.
	 *
	 * <p>The following example sets the gap used for the button layout to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.gap = 20;</listing>
	 *
	 * @default 0
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
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

	/**
	 * @private
	 */
	private var _firstGap:Float = Math.NaN;

	/**
	 * Space, in pixels, between the first two buttons. If <code>Math.NaN</code>,
	 * the default <code>gap</code> property will be used.
	 *
	 * <p>The following example sets the gap between the first and second
	 * button to a different value than the standard gap:</p>
	 *
	 * <listing version="3.0">
	 * group.firstGap = 30;
	 * group.gap = 20;</listing>
	 *
	 * @default Math.NaN
	 *
	 * @see #gap
	 * @see #lastGap
	 */
	public var firstGap(get, set):Float;
	public function get_firstGap():Float
	{
		return this._firstGap;
	}

	/**
	 * @private
	 */
	public function set_firstGap(value:Float):Float
	{
		if(this._firstGap == value)
		{
			return get_firstGap();
		}
		this._firstGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_firstGap();
	}

	/**
	 * @private
	 */
	private var _lastGap:Float = Math.NaN;

	/**
	 * Space, in pixels, between the last two buttons. If <code>Math.NaN</code>,
	 * the default <code>gap</code> property will be used.
	 *
	 * <p>The following example sets the gap between the last and next to last
	 * button to a different value than the standard gap:</p>
	 *
	 * <listing version="3.0">
	 * group.lastGap = 30;
	 * group.gap = 20;</listing>
	 *
	 * @default Math.NaN
	 *
	 * @see #gap
	 * @see #firstGap
	 */
	public var lastGap(get, set):Float;
	public function get_lastGap():Float
	{
		return this._lastGap;
	}

	/**
	 * @private
	 */
	public function set_lastGap(value:Float):Float
	{
		if(this._lastGap == value)
		{
			return get_lastGap();
		}
		this._lastGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_lastGap();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding of all sides of the group
	 * is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the group's top edge and the
	 * group's buttons.
	 *
	 * <p>In the following example, the padding on the top edge of the
	 * group is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
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

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the group's right edge and the
	 * group's buttons.
	 *
	 * <p>In the following example, the padding on the right edge of the
	 * group is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
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

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the group's bottom edge and the
	 * group's buttons.
	 *
	 * <p>In the following example, the padding on the bottom edge of the
	 * group is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
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

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the group's left edge and the
	 * group's buttons.
	 *
	 * <p>In the following example, the padding on the left edge of the
	 * group is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * group.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
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

	/**
	 * @private
	 */
	private var _buttonFactory:Void->Button = defaultButtonFactory;

	/**
	 * Creates a new button. A button must be an instance of <code>Button</code>.
	 * This factory can be used to change properties on the buttons when
	 * they are first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on a button.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * <p>The following example skins the buttons using a custom button
	 * factory:</p>
	 *
	 * <listing version="3.0">
	 * group.buttonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( texture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #firstButtonFactory
	 * @see #lastButtonFactory
	 */
	public var buttonFactory(get, set):Void->Button;
	public function get_buttonFactory():Void->Button
	{
		return this._buttonFactory;
	}

	/**
	 * @private
	 */
	public function set_buttonFactory(value:Void->Button):Void->Button
	{
		if(this._buttonFactory == value)
		{
			return get_buttonFactory();
		}
		this._buttonFactory = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_buttonFactory();
	}

	/**
	 * @private
	 */
	private var _firstButtonFactory:Void->Button;

	/**
	 * Creates a new first button. If the <code>firstButtonFactory</code> is
	 * <code>null</code>, then the button group will use the <code>buttonFactory</code>.
	 * The first button must be an instance of <code>Button</code>. This
	 * factory can be used to change properties on the first button when
	 * it is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the first button.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * <p>The following example skins the first button using a custom
	 * factory:</p>
	 *
	 * <listing version="3.0">
	 * group.firstButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( texture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #buttonFactory
	 * @see #lastButtonFactory
	 */
	public var firstButtonFactory(get, set):Void->Button;
	public function get_firstButtonFactory():Void->Button
	{
		return this._firstButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_firstButtonFactory(value:Void->Button):Void->Button
	{
		if(this._firstButtonFactory == value)
		{
			return get_firstButtonFactory();
		}
		this._firstButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_firstButtonFactory();
	}

	/**
	 * @private
	 */
	private var _lastButtonFactory:Void->Button;

	/**
	 * Creates a new last button. If the <code>lastButtonFactory</code> is
	 * <code>null</code>, then the button group will use the <code>buttonFactory</code>.
	 * The last button must be an instance of <code>Button</code>. This
	 * factory can be used to change properties on the last button when
	 * it is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the last button.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * <p>The following example skins the last button using a custom
	 * factory:</p>
	 *
	 * <listing version="3.0">
	 * group.lastButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( texture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #buttonFactory
	 * @see #firstButtonFactory
	 */
	public var lastButtonFactory(get, set):Void->Button;
	public function get_lastButtonFactory():Void->Button
	{
		return this._lastButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_lastButtonFactory(value:Void->Button):Void->Button
	{
		if(this._lastButtonFactory == value)
		{
			return get_lastButtonFactory();
		}
		this._lastButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_lastButtonFactory();
	}

	/**
	 * @private
	 */
	private var _buttonInitializer:Button->Dynamic->Void/* = defaultButtonInitializer*/;

	/**
	 * Modifies a button, perhaps by changing its label and icons, based on the
	 * item from the data provider that the button is meant to represent. The
	 * default buttonInitializer function can set the button's label and icons if
	 * <code>label</code> and/or any of the <code>Button</code> icon fields
	 * (<code>defaultIcon</code>, <code>upIcon</code>, etc.) are present in
	 * the item. You can listen to <code>Event.TRIGGERED</code> and
	 * <code>Event.CHANGE</code> by passing in functions for each.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function( button:Button, item:Dynamic ):Void</pre>
	 *
	 * <p>The following example provides a custom button initializer:</p>
	 *
	 * <listing version="3.0">
	 * group.buttonInitializer = function( button:Button, item:Dynamic ):Void
	 * {
	 *     button.label = item.label;
	 * };</listing>
	 *
	 * @see #dataProvider
	 */
	public var buttonInitializer(get, set):Button->Dynamic->Void;
	public function get_buttonInitializer():Button->Dynamic->Void
	{
		return this._buttonInitializer;
	}

	/**
	 * @private
	 */
	public function set_buttonInitializer(value:Button->Dynamic->Void):Button->Dynamic->Void
	{
		if(this._buttonInitializer == value)
		{
			return get_buttonInitializer();
		}
		this._buttonInitializer = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_buttonInitializer();
	}

	/**
	 * @private
	 */
	private var _customButtonStyleName:String;

	/**
	 * A style name to add to all buttons in this button group. Typically
	 * used by a theme to provide different styles to different button groups.
	 *
	 * <p>The following example provides a custom button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customButtonStyleName = "my-custom-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-button", setCustomButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customButtonStyleName(get, set):String;
	public function get_customButtonStyleName():String
	{
		return this._customButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customButtonStyleName(value:String):String
	{
		if(this._customButtonStyleName == value)
		{
			return get_customButtonStyleName();
		}
		this._customButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_customButtonStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customButtonStyleName
	 */
	public var customButtonName(get, set):String;
	public function get_customButtonName():String
	{
		return this.customButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customButtonName(value:String):String
	{
		this.customButtonStyleName = value;
		return get_customButtonName();
	}

	/**
	 * @private
	 */
	private var _customFirstButtonStyleName:String;

	/**
	 * A style name to add to the first button in this button group.
	 * Typically used by a theme to provide different styles to the first
	 * button.
	 *
	 * <p>The following example provides a custom first button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customFirstButtonStyleName = "my-custom-first-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-first-button", setCustomFirstButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customFirstButtonStyleName(get, set):String;
	public function get_customFirstButtonStyleName():String
	{
		return this._customFirstButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customFirstButtonStyleName(value:String):String
	{
		if(this._customFirstButtonStyleName == value)
		{
			return get_customFirstButtonStyleName();
		}
		this._customFirstButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_customFirstButtonStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customFirstButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customFirstButtonStyleName
	 */
	public var customFirstButtonName(get, set):String;
	public function get_customFirstButtonName():String
	{
		return this.customFirstButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customFirstButtonName(value:String):String
	{
		this.customFirstButtonStyleName = value;
		return get_customFirstButtonName();
	}

	/**
	 * @private
	 */
	private var _customLastButtonStyleName:String;

	/**
	 * A style name to add to the last button in this button group.
	 * Typically used by a theme to provide different styles to the last
	 * button.
	 *
	 * <p>The following example provides a custom last button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customLastButtonStyleName = "my-custom-last-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-last-button", setCustomLastButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customLastButtonStyleName(get, set):String;
	public function get_customLastButtonStyleName():String
	{
		return this._customLastButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customLastButtonStyleName(value:String):String
	{
		if(this._customLastButtonStyleName == value)
		{
			return get_customLastButtonStyleName();
		}
		this._customLastButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_customLastButtonStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customLastButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customLastButtonStyleName
	 */
	public var customLastButtonName(get, set):String;
	public function get_customLastButtonName():String
	{
		return this.customLastButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customLastButtonName(value:String):String
	{
		this.customLastButtonStyleName = value;
		return get_customLastButtonName();
	}

	/**
	 * @private
	 */
	private var _buttonProperties:PropertyProxy;

	/**
	 * An object that stores properties for all of the button group's
	 * buttons, and the properties will be passed down to every button when
	 * the button group validates. For a list of available properties,
	 * refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 * 
	 * <p>These properties are shared by every button, so anything that cannot
	 * be shared (such as display objects, which cannot be added to multiple
	 * parents) should be passed to buttons using the
	 * <code>buttonFactory</code> or in the theme.</p>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>The following example sets some properties on all of the buttons:</p>
	 *
	 * <listing version="3.0">
	 * group.buttonProperties.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
	 * group.buttonProperties.verticalAlign = Button.VERTICAL_ALIGN_TOP;</listing>
	 *
	 * <p>Setting properties in a <code>buttonFactory</code> function instead
	 * of using <code>buttonProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #buttonFactory
	 * @see #firstButtonFactory
	 * @see #lastButtonFactory
	 * @see feathers.controls.Button
	 */
	public var buttonProperties(get, set):PropertyProxy;
	public function get_buttonProperties():PropertyProxy
	{
		if(this._buttonProperties == null)
		{
			this._buttonProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._buttonProperties;
	}

	/**
	 * @private
	 */
	public function set_buttonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._buttonProperties == value)
		{
			return get_buttonProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!Std.is(value, PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			/*for(propertyName in Reflect.fields(value.storage))
			{
				Reflect.setProperty(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}*/
			DataProperties.copyValuesFromDictionaryTo(value.storage,newValue.storage);
			value = newValue;
		}
		if(this._buttonProperties != null)
		{
			this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._buttonProperties = value;
		if(this._buttonProperties != null)
		{
			this._buttonProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_buttonProperties();
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.dataProvider = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var buttonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		if(dataInvalid || stateInvalid || buttonFactoryInvalid)
		{
			this.refreshButtons(buttonFactoryInvalid);
		}

		if(dataInvalid || buttonFactoryInvalid || stylesInvalid)
		{
			this.refreshButtonStyles();
		}

		if(dataInvalid || stateInvalid || buttonFactoryInvalid)
		{
			this.commitEnabled();
		}

		if(stylesInvalid)
		{
			this.refreshLayoutStyles();
		}

		this.layoutButtons();
	}

	/**
	 * @private
	 */
	private function commitEnabled():Void
	{
		var buttonCount:Int = this.activeButtons.length;
		for(i in 0 ... buttonCount)
		{
			var button:Button = this.activeButtons[i];
			button.isEnabled = button.isEnabled && this._isEnabled;
		}
	}

	/**
	 * @private
	 */
	private function refreshButtonStyles():Void
	{
		if (this._buttonProperties == null)
			return;
			
		//DataProperties.copyValuesFromObjectTo(_buttonProperties.storage, button);
		
		for(propertyName in Reflect.fields(this._buttonProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._buttonProperties.storage, propertyName);
			for (button in this.activeButtons)
			{
				Reflect.setProperty(button, propertyName, propertyValue);
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshLayoutStyles():Void
	{
		if(this._direction == DIRECTION_VERTICAL)
		{
			if(this.horizontalLayout != null)
			{
				this.horizontalLayout = null;
			}
			if(this.verticalLayout == null)
			{
				this.verticalLayout = new VerticalLayout();
				this.verticalLayout.useVirtualLayout = false;
			}
			this.verticalLayout.distributeHeights = this._distributeButtonSizes;
			this.verticalLayout.horizontalAlign = this._horizontalAlign;
			this.verticalLayout.verticalAlign = (this._verticalAlign == VERTICAL_ALIGN_JUSTIFY) ? VERTICAL_ALIGN_TOP : this._verticalAlign;
			this.verticalLayout.gap = this._gap;
			this.verticalLayout.firstGap = this._firstGap;
			this.verticalLayout.lastGap = this._lastGap;
			this.verticalLayout.paddingTop = this._paddingTop;
			this.verticalLayout.paddingRight = this._paddingRight;
			this.verticalLayout.paddingBottom = this._paddingBottom;
			this.verticalLayout.paddingLeft = this._paddingLeft;
		}
		else //horizontal
		{
			if(this.verticalLayout != null)
			{
				this.verticalLayout = null;
			}
			if(this.horizontalLayout == null)
			{
				this.horizontalLayout = new HorizontalLayout();
				this.horizontalLayout.useVirtualLayout = false;
			}
			this.horizontalLayout.distributeWidths = this._distributeButtonSizes;
			this.horizontalLayout.horizontalAlign = (this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY) ? HORIZONTAL_ALIGN_LEFT : this._horizontalAlign;
			this.horizontalLayout.verticalAlign = this._verticalAlign;
			this.horizontalLayout.gap = this._gap;
			this.horizontalLayout.firstGap = this._firstGap;
			this.horizontalLayout.lastGap = this._lastGap;
			this.horizontalLayout.paddingTop = this._paddingTop;
			this.horizontalLayout.paddingRight = this._paddingRight;
			this.horizontalLayout.paddingBottom = this._paddingBottom;
			this.horizontalLayout.paddingLeft = this._paddingLeft;
		}
	}

	/**
	 * @private
	 */
	private function defaultButtonInitializer(button:Button, item:Dynamic):Void
	{
		//if(Std.is(item, Dynamic))
		{
		//	if (item.hasOwnProperty(LABEL_FIELD))
			if (Reflect.hasField(item,LABEL_FIELD))
			{
				button.label = cast(item.label, String);
			}
			else
			{
				button.label = item.toString();
			}
			//if (item.hasOwnProperty(ENABLED_FIELD))
			if (Reflect.hasField(item,ENABLED_FIELD))
			{
				button.isEnabled = Boolean.isTrue(item.isEnabled);
			}
			else
			{
				button.isEnabled = this._isEnabled;
			}
			for (field in DEFAULT_BUTTON_FIELDS)
			{
				var prop:Dynamic = Reflect.getProperty(item, field);
				if(prop != null)
				{
					Reflect.setProperty(button, field, prop);
				}
			}
			for (field in DEFAULT_BUTTON_EVENTS)
			{
				var removeListener:Bool = true;
				//if (item.hasOwnProperty(field))
				if (Reflect.hasField(item,field))
				{
					var listener:Dynamic = Reflect.getProperty(item, field);
					if(listener == null)
					{
						continue;
					}
					removeListener =  false;
					//we can't add the listener directly because we don't
					//know how to remove it later if the data provider
					//changes and we lose the old item. we'll use another
					//event listener that we control as a delegate, and
					//we'll be able to remove it later.
					button.addEventListener(field, defaultButtonEventsListener);
				}
				if(removeListener)
				{
					button.removeEventListener(field, defaultButtonEventsListener);
				}
			}
		}
		/*else
		{
			button.label = "";
		}*/
	}

	/**
	 * @private
	 */
	private function refreshButtons(isFactoryInvalid:Bool):Void
	{
		var temp:Array<Button> = this.inactiveButtons;
		this.inactiveButtons = this.activeButtons;
		this.activeButtons = temp;
		this.activeButtons.splice(0, this.activeButtons.length);
		this._layoutItems.splice(0, this._layoutItems.length);
		temp = null;
		if(isFactoryInvalid)
		{
			this.clearInactiveButtons();
		}
		else
		{
			if(this.activeFirstButton != null)
			{
				this.inactiveButtons.shift();
			}
			this.inactiveFirstButton = this.activeFirstButton;

			if(this.activeLastButton != null)
			{
				this.inactiveButtons.pop();
			}
			this.inactiveLastButton = this.activeLastButton;
		}
		this.activeFirstButton = null;
		this.activeLastButton = null;

		var pushIndex:Int = 0;
		var itemCount:Int = this._dataProvider != null ? this._dataProvider.length : 0;
		var lastItemIndex:Int = itemCount - 1;
		for(i in 0 ... itemCount)
		{
			var item:Dynamic = this._dataProvider.getItemAt(i);
			var button:Button;
			if(i == 0)
			{
				button = this.activeFirstButton = this.createFirstButton(item);
			}
			else if(i == lastItemIndex)
			{
				button = this.activeLastButton = this.createLastButton(item);
			}
			else
			{
				button = this.createButton(item);
			}
			this.activeButtons[pushIndex] = button;
			this._layoutItems[pushIndex] = button;
			pushIndex++;
		}
		this.clearInactiveButtons();
	}

	/**
	 * @private
	 */
	private function clearInactiveButtons():Void
	{
		var itemCount:Int = this.inactiveButtons.length;
		for(i in 0 ... itemCount)
		{
			var button:Button = this.inactiveButtons.shift();
			this.destroyButton(button);
		}

		if(this.inactiveFirstButton != null)
		{
			this.destroyButton(this.inactiveFirstButton);
			this.inactiveFirstButton = null;
		}

		if(this.inactiveLastButton != null)
		{
			this.destroyButton(this.inactiveLastButton);
			this.inactiveLastButton = null;
		}
	}

	/**
	 * @private
	 */
	private function createFirstButton(item:Dynamic):Button
	{
		var isNewInstance:Bool = false;
		var button:Button;
		if(this.inactiveFirstButton != null)
		{
			button = this.inactiveFirstButton;
			this.inactiveFirstButton = null;
		}
		else
		{
			isNewInstance = true;
			var factory:Void->Button = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
			button = factory();
			if(this._customFirstButtonStyleName != null)
			{
				button.styleNameList.add(this._customFirstButtonStyleName);
			}
			else if(this._customButtonStyleName != null)
			{
				button.styleNameList.add(this._customButtonStyleName);
			}
			else
			{
				button.styleNameList.add(this.firstButtonStyleName);
			}
			this.addChild(button);
		}
		this._buttonInitializer(button, item);
		if(isNewInstance)
		{
			//we need to listen for Event.TRIGGERED after the initializer
			//is called to avoid runtime errors because the button may be
			//disposed by the time listeners in the initializer are called.
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
		}
		return button;
	}

	/**
	 * @private
	 */
	private function createLastButton(item:Dynamic):Button
	{
		var isNewInstance:Bool = false;
		var button:Button;
		if(this.inactiveLastButton != null)
		{
			button = this.inactiveLastButton;
			this.inactiveLastButton = null;
		}
		else
		{
			isNewInstance = true;
			var factory:Void->Button = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
			button = factory();
			if(this._customLastButtonStyleName != null)
			{
				button.styleNameList.add(this._customLastButtonStyleName);
			}
			else if(this._customButtonStyleName != null)
			{
				button.styleNameList.add(this._customButtonStyleName);
			}
			else
			{
				button.styleNameList.add(this.lastButtonStyleName);
			}
			this.addChild(button);
		}
		this._buttonInitializer(button, item);
		if(isNewInstance)
		{
			//we need to listen for Event.TRIGGERED after the initializer
			//is called to avoid runtime errors because the button may be
			//disposed by the time listeners in the initializer are called.
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
		}
		return button;
	}

	/**
	 * @private
	 */
	private function createButton(item:Dynamic):Button
	{
		var isNewInstance:Bool = false;
		var button:Button = null;
		if(this.inactiveButtons.length == 0)
		{
			isNewInstance = true;
			button = this._buttonFactory();
			if(this._customButtonStyleName != null)
			{
				button.styleNameList.add(this._customButtonStyleName);
			}
			else
			{
				button.styleNameList.add(this.buttonStyleName);
			}
			this.addChild(button);
		}
		else
		{
			button = this.inactiveButtons.shift();
		}
		this._buttonInitializer(button, item);
		if(isNewInstance)
		{
			//we need to listen for Event.TRIGGERED after the initializer
			//is called to avoid runtime errors because the button may be
			//disposed by the time listeners in the initializer are called.
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
		}
		return button;
	}

	/**
	 * @private
	 */
	private function destroyButton(button:Button):Void
	{
		button.removeEventListener(Event.TRIGGERED, button_triggeredHandler);
		this.removeChild(button, true);
	}

	/**
	 * @private
	 */
	private function layoutButtons():Void
	{
		this._viewPortBounds.x = 0;
		this._viewPortBounds.y = 0;
		this._viewPortBounds.scrollX = 0;
		this._viewPortBounds.scrollY = 0;
		this._viewPortBounds.explicitWidth = this.explicitWidth;
		this._viewPortBounds.explicitHeight = this.explicitHeight;
		this._viewPortBounds.minWidth = this._minWidth;
		this._viewPortBounds.minHeight = this._minHeight;
		this._viewPortBounds.maxWidth = this._maxWidth;
		this._viewPortBounds.maxHeight = this._maxHeight;
		if(this.verticalLayout != null)
		{
			this.verticalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
		}
		else if(this.horizontalLayout != null)
		{
			this.horizontalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
		}
		this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
		//final validation to avoid juggler next frame issues
		for (button in this.activeButtons)
		{
			button.validate();
		}
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function dataProvider_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function button_triggeredHandler(event:Event):Void
	{
		//if this was called after dispose, ignore it
		if(this._dataProvider == null || this.activeButtons == null)
		{
			return;
		}
		var button:Button = cast(event.currentTarget, Button);
		var index:Int = this.activeButtons.indexOf(button);
		var item:Dynamic = this._dataProvider.getItemAt(index);
		this.dispatchEventWith(Event.TRIGGERED, false, item);
	}

	/**
	 * @private
	 */
	private function defaultButtonEventsListener(event:Event):Void
	{
		var button:Button = cast(event.currentTarget, Button);
		var index:Int = this.activeButtons.indexOf(button);
		var item:Dynamic = this._dataProvider.getItemAt(index);
		var field:String = event.type;
		//if (item.hasOwnProperty(field))
		if (Reflect.hasField(item,field))
		{
			var listener:Dynamic = Reflect.getProperty(item, field);
			if(listener == null)
			{
				return;
			}
			listener(event, event.data);
			/*var argCount:Int = listener.length;
			if(argCount == 1)
			{
				listener(event);
			}
			else if(argCount == 2)
			{
				listener(event, event.data);
			}
			else
			{
				listener();
			}*/
		}
	}
}
