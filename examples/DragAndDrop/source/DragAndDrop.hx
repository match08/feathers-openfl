package;
import feathers.examples.dragDrop.Main;
import openfl.errors.Error;
import starling.utils.Max;

import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.geom.Rectangle;

import starling.core.Starling;

//[SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
class DragAndDrop extends Sprite
{
	public function new()
	{
		super();
		if(this.stage != null)
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
		}
		this.mouseEnabled = this.mouseChildren = false;
		//this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		loaderInfo_completeHandler(new Event(Event.COMPLETE));
	}

	private var _starling:Starling;

	private function loaderInfo_completeHandler(event:Event):Void
	{
		Starling.multitouchEnabled = true;
		this._starling = new Starling(Main, this.stage);
		this._starling.supportHighResolutions = true;
		this._starling.start();

		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, Max.INT_MAX_VALUE, true);
		this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
	}

	private function stage_resizeHandler(event:Event):Void
	{
		this._starling.stage.stageWidth = this.stage.stageWidth;
		this._starling.stage.stageHeight = this.stage.stageHeight;

		var viewPort:Rectangle = this._starling.viewPort;
		viewPort.width = this.stage.stageWidth;
		viewPort.height = this.stage.stageHeight;
		try
		{
			this._starling.viewPort = viewPort;
		}
		catch(error:Error) {}
	}

	private function stage_deactivateHandler(event:Event):Void
	{
		this._starling.stop(true);
		this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
	}

	private function stage_activateHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
		this._starling.start();
	}

}