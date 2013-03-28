package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	import view.TabController;
	
	[SWF(width="640",height="960",frameRate="60",backgroundColor="#2f2f2f")]
	public class ANEStudy extends Sprite
	{
		private var _starling:Starling;
		
		public function ANEStudy()
		{
			if(stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			mouseEnabled = mouseChildren = false;
			loaderInfo.addEventListener(Event.COMPLETE, onCompleteLoaderInfo);			
		}
		
		private function onCompleteLoaderInfo(event:Event):void
		{
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, Constants.STAGE_WIDTH, Constants.STAGE_HEIGHT), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			
			Constants.SCALE_VECTOR = viewPort.width < 480 ? 1 : 2;
			Constants.SCALE = 1 / Constants.SCALE_VECTOR;
			
			Starling.handleLostContext = true;
			//Starling.multitouchEnabled = true;
			_starling = new Starling(TabController, stage);
			_starling.enableErrorChecking = false;
			//_starling.showStats = true;
			//_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			_starling.start();
			
			stage.addEventListener(Event.RESIZE, onResizeStage, false, int.MAX_VALUE, true);
			stage.addEventListener(Event.DEACTIVATE, onDeactivateStage, false, 0, true);
		}
		
		private function onResizeStage(event:Event):void
		{
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;
			try
			{
				_starling.viewPort = viewPort;
			}
			catch(error:Error) {}
			//_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		}
		
		private function onDeactivateStage(event:Event):void
		{
			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onActivateStage, false, 0, true);
		}
		
		private function onActivateStage(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onActivateStage);
			_starling.start();
		}
		
		
	}
}

