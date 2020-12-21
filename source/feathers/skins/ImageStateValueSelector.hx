/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import starling.display.Image;
import starling.textures.Texture;

/**
 * Values for each state are Texture instances, and the manager attempts to
 * reuse the existing Image instance that is passed in to getValueForState()
 * as the old value by swapping the texture.
 */
class ImageStateValueSelector extends StateWithToggleValueSelector
{
	/**
	 * Constructor.
	 */
	public function new()
	{
	}

	/**
	 * @private
	 */
	private var _imageProperties:Dynamic;

	/**
	 * Optional properties to set on the Image instance.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Image.html starling.display.Image
	 */
	public var imageProperties(get, set):PropertyProxy;
	public function get_imageProperties():PropertyProxy
	{
		if(!this._imageProperties)
		{
			this._imageProperties = {};
		}
		return this._imageProperties;
	}

	/**
	 * @private
	 */
	public function set_imageProperties(value:PropertyProxy):PropertyProxy
	{
		this._imageProperties = value;
	}

	/**
	 * @private
	 */
	override public function setValueForState(value:Dynamic, state:Dynamic, isSelected:Bool = false):Void
	{
		if(!(Std.is(value, Texture)))
		{
			throw new ArgumentError("Value for state must be a Texture instance.");
		}
		super.setValueForState(value, state, isSelected);
	}

	/**
	 * @private
	 */
	override public function updateValue(target:Dynamic, state:Dynamic, oldValue:Dynamic = null):Dynamic
	{
		var texture:Texture = super.updateValue(target, state) as Texture;
		if(!texture)
		{
			return null;
		}

		if(Std.is(oldValue, Image))
		{
			var image:Image = Image(oldValue);
			image.texture = texture;
			image.readjustSize();
		}
		else
		{
			image = new Image(texture);
		}

		for (propertyName in this._imageProperties)
		{
			var propertyValue:Dynamic = this._imageProperties[propertyName];
			image[propertyName] = propertyValue;
		}

		return image;
	}
}
