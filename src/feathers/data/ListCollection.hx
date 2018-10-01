/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import feathers.events.CollectionEventType;

import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when the underlying data source changes and the ui will
 * need to redraw the data.
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
 */
///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the collection has changed drastically, such as when
 * the underlying data source is replaced completely.
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
 * @eventType feathers.events.CollectionEventType.RESET
 */
///[Event(name="reset",type="starling.events.Event")]

/**
 * Dispatched when an item is added to the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index of the item that has been
 * added. It is of type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.ADD_ITEM
 */
///[Event(name="addItem",type="starling.events.Event")]

/**
 * Dispatched when an item is removed from the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index of the item that has been
 * removed. It is of type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
 */
///[Event(name="removeItem",type="starling.events.Event")]

/**
 * Dispatched when an item is replaced in the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index of the item that has been
 * replaced. It is of type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.REPLACE_ITEM
 */
///[Event(name="replaceItem",type="starling.events.Event")]

/**
 * Dispatched when a property of an item in the collection has changed
 * and the item doesn't have its own change event or signal. This event
 * is only dispatched when the <code>updateItemAt()</code> function is
 * called on the <code>ListCollection</code>.
 *
 * <p>In general, it's better for the items themselves to dispatch events
 * or signals when their properties change.</p>
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index of the item that has been
 * updated. It is of type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
 */
///[Event(name="updateItem",type="starling.events.Event")]

/**
 * Wraps a data source with a common API for use with UI controls, like
 * lists, that support one dimensional collections of data. Supports custom
 * "data descriptors" so that unexpected data sources may be used. Supports
 * Arrays, Vectors, and XMLLists automatically.
 * 
 * @see ArrayListCollectionDataDescriptor
 * @see VectorListCollectionDataDescriptor
 * @see XMLListListCollectionDataDescriptor
 */
class ListCollection extends EventDispatcher
{
	/**
	 * Constructor
	 */
	public function new(data:Dynamic = null)
	{
		super();
		if(data == null)
		{
			//default to an array if no data is provided
			data = [];
		}
		this.data = data;

	}
	
	/**
	 * @private
	 */
	private var _data:Dynamic;
	
	/**
	 * The data source for this collection. May be any type of data, but a
	 * <code>dataDescriptor</code> needs to be provided to translate from
	 * the data source's APIs to something that can be understood by
	 * <code>ListCollection</code>.
	 * 
	 * <p>Data sources of type Array, Vector, and XMLList are automatically
	 * detected, and no <code>dataDescriptor</code> needs to be set if the
	 * <code>ListCollection</code> uses one of these types.</p>
	 */
	public var data(get, set):Dynamic;
	public function get_data():Dynamic
	{
		return _data;
	}
	
	/**
	 * @private
	 */
	public function set_data(value:Dynamic):Dynamic
	{
		if(_data == value)
		{
			return _data;
		}
		if(value == null)
		{
			removeAll();
			return _data;
		}
		_data = value;
		
		
		//trace("LIST COLLECTION: set_data!");
		//we'll automatically detect an array, vector, or xmllist for convenience
		if(Std.is(_data, Array) && !Std.is(_dataDescriptor, ArrayListCollectionDataDescriptor))
		{
			dataDescriptor = new ArrayListCollectionDataDescriptor();
		}
		
		dispatchEventWith(CollectionEventType.RESET);
		dispatchEventWith(Event.CHANGE);

		return _data;
	}
	
	/**
	 * @private
	 */
	private var _dataDescriptor:IListCollectionDataDescriptor;

	/**
	 * Describes the underlying data source by translating APIs.
	 * 
	 * @see IListCollectionDataDescriptor
	 */
	public var dataDescriptor(get, set):IListCollectionDataDescriptor;
	public function get_dataDescriptor():IListCollectionDataDescriptor
	{
		return this._dataDescriptor;
	}
	
	/**
	 * @private
	 */
	public function set_dataDescriptor(value:IListCollectionDataDescriptor):IListCollectionDataDescriptor
	{
		if(this._dataDescriptor == value)
		{
			return this._dataDescriptor;
		}
		this._dataDescriptor = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
		return this._dataDescriptor;
	}

	/**
	 * The number of items in the collection.
	 */
	public var length(get, never):Int;
	public function get_length():Int
	{
		return this._dataDescriptor.getLength(this._data);
	}

	/**
	 * If an item doesn't dispatch an event or signal to indicate that it
	 * has changed, you can manually tell the collection about the change,
	 * and the collection will dispatch the <code>CollectionEventType.UPDATE_ITEM</code>
	 * event to manually notify the component that renders the data.
	 */
	public function updateItemAt(index:Int):Void
	{
		this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
	}
	
	/**
	 * Returns the item at the specified index in the collection.
	 */
	public function getItemAt(index:Int):Dynamic
	{
		return this._dataDescriptor.getItemAt(this._data, index);
	}
	
	/**
	 * Determines which index the item appears at within the collection. If
	 * the item isn't in the collection, returns <code>-1</code>.
	 */
	public function getItemIndex(item:Dynamic):Int
	{
		return this._dataDescriptor.getItemIndex(this._data, item);
	}
	
	/**
	 * Adds an item to the collection, at the specified index.
	 */
	public function addItemAt(item:Dynamic, index:Int):Void
	{

		_dataDescriptor.addItemAt(_data, item, index);
		dispatchEventWith(Event.CHANGE);
		dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
	}
	
	/**
	 * Removes the item at the specified index from the collection and
	 * returns it.
	 */
	public function removeItemAt(index:Int):Dynamic
	{

		var item:Dynamic = this._dataDescriptor.removeItemAt(this._data, index);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
		return item;
	}
	
	/**
	 * Removes a specific item from the collection.
	 */
	public function removeItem(item:Dynamic):Void
	{
		var index:Int = this.getItemIndex(item);
		if(index >= 0)
		{
			this.removeItemAt(index);
		}
	}

	/**
	 * Removes all items from the collection.
	 */
	public function removeAll():Void
	{

		if(this.length == 0)
		{
			return;
		}
		this._dataDescriptor.removeAll(this._data);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.RESET, false);
	}
	
	/**
	 * Replaces the item at the specified index with a new item.
	 */
	public function setItemAt(item:Dynamic, index:Int):Void
	{
	
		this._dataDescriptor.setItemAt(this._data, item, index);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
	}

	/**
	 * Adds an item to the end of the collection.
	 */
	public function addItem(item:Dynamic):Void
	{
		this.addItemAt(item, this.length);
	}

	/**
	 * Adds an item to the end of the collection.
	 */
	public function push(item:Dynamic):Void
	{
		this.addItemAt(item, this.length);
	}

	/**
	 * Adds all items from another collection.
	 */
	public function addAll(collection:ListCollection):Void
	{
	
		var otherCollectionLength:Int = collection.length;
		//for(var i:Int = 0; i < otherCollectionLength; i++)
		for(i in 0 ... otherCollectionLength)
		{
			var item:Dynamic = collection.getItemAt(i);
			this.addItem(item);
		}
	}

	/**
	 * Adds all items from another collection, placing the items at a
	 * specific index in this collection.
	 */
	public function addAllAt(collection:ListCollection, index:Int):Void
	{
		var otherCollectionLength:Int = collection.length;
		var currentIndex:Int = index;
		//for(var i:Int = 0; i < otherCollectionLength; i++)
		for(i in 0 ... otherCollectionLength)
		{
			var item:Dynamic = collection.getItemAt(i);
			this.addItemAt(item, currentIndex);
			currentIndex++;
		}
	}
	
	/**
	 * Removes the item from the end of the collection and returns it.
	 */
	public function pop():Dynamic
	{
		return this.removeItemAt(this.length - 1);
	}
	
	/**
	 * Adds an item to the beginning of the collection.
	 */
	public function unshift(item:Dynamic):Void
	{
		this.addItemAt(item, 0);
	}
	
	/**
	 * Removed the item from the beginning of the collection and returns it. 
	 */
	public function shift():Dynamic
	{
		return this.removeItemAt(0);
	}

	/**
	 * Determines if the specified item is in the collection.
	 */
	public function contains(item:Dynamic):Bool
	{
		return this.getItemIndex(item) >= 0;
	}

	/**
	 * Calls a function for each item in the collection that may be used
	 * to dispose any properties on the item. For example, display objects
	 * or textures may need to be disposed.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Void</pre>
	 *
	 * <p>In the following example, the items in the collection are disposed:</p>
	 *
	 * <listing version="3.0">
	 * collection.dispose( function( item:Dynamic ):Void
	 * {
	 *     var accessory:DisplayObject = DisplayObject(item.accessory);
	 *     accessory.dispose();
	 * }</listing>
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
	 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
	 */
	public function dispose(disposeItem:Dynamic):Void
	{
		var itemCount:Int = this.length;
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var item:Dynamic = this.getItemAt(i);
			disposeItem(item);
		}
	}
}