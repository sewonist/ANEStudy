package
{
	import com.itpointlab.ane.ScreenWakeUp;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.VAlign;
	
	import view.TabController;
	
	[SWF(width="640",height="960",frameRate="60",backgroundColor="#2f2f2f")]
	public class ANEStudy extends Sprite
	{
		private var _starling:Starling;
		private var _screen:ScreenWakeUp;
		
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
			_screen = new ScreenWakeUp;
			_screen.lock(true);
			
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
			_starling.showStats = true;
			_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
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

/*
package
{
	import com.danielfreeman.madcomponents.UIButton;
	import com.itpointlab.ane.CustomObject;
	import com.itpointlab.ane.FlashLight;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(frameRate="60", width="640", height="960")]
	public class ANEStudy extends Sprite
	{
		private var _flash:FlashLight;
		private var _on:Boolean = false;
		private var _button:UIButton;
		private var _button2:UIButton;
		private var _dummy:Object;
		private var _button3:UIButton;
		
		private var _buttons:Vector.<UIButton>;
		private var _button5:Object;
		private var _button4:Object;
		private var _buttonOn:Object;
		private var _buttonOff:UIButton;
		private var _buttonSum:UIButton;
		
		public function ANEStudy()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_dummy = {x:1};
			
			_button = new UIButton(this, 120, 50, "getBoolean");
			_button.scaleX = 2;
			_button.scaleY = 2;
			_button.addEventListener(MouseEvent.CLICK, onClickButtons);
			
			_button2 = new UIButton(this, 120, 150, "getInt");
			_button2.scaleX = 2;
			_button2.scaleY = 2;
			_button2.addEventListener(MouseEvent.CLICK, onClickButtons);
			
			_button3 = new UIButton(this, 120, 250, "getString");
			_button3.scaleX = 2;
			_button3.scaleY = 2;
			_button3.addEventListener(MouseEvent.CLICK, onClickButtons);
			
			_button4 = new UIButton(this, 120, 350, "getArray");
			_button4.scaleX = 2;
			_button4.scaleY = 2;
			_button4.addEventListener(MouseEvent.CLICK, onClickButtons);
			
			_button5 = new UIButton(this, 120, 450, "getCustomObject");
			_button5.scaleX = 2;
			_button5.scaleY = 2;
			_button5.addEventListener(MouseEvent.CLICK, onClickButtons);
			
			_buttonOn = new UIButton(this, 120, 550, "Turn ON");
			_buttonOn.scaleX = 2;
			_buttonOn.scaleY = 2;
			_buttonOn.addEventListener(MouseEvent.CLICK, onClickButtonOn);
			
			_buttonOff = new UIButton(this, 120, 650, "Turn OFF");
			_buttonOff.scaleX = 2;
			_buttonOff.scaleY = 2;
			_buttonOff.addEventListener(MouseEvent.CLICK, onClickButtonOff);
			
			_buttonSum = new UIButton(this, 120, 750, "SUM");
			_buttonSum.scaleX = 2;
			_buttonSum.scaleY = 2;
			_buttonSum.addEventListener(MouseEvent.CLICK, onClickButtonSUM);
			
			_flash = new FlashLight;
			_flash.addEventListener(Event.ACTIVATE, onChange);
			_flash.addEventListener(Event.DEACTIVATE, onChange);
		}
		
		protected function onClickButtonSUM(event:MouseEvent):void
		{
			trace(_flash.nativeSum('steve.jobs', 11111));
		}
		
		protected function onChange(event:Event):void
		{
			trace(event);
		}
		
		protected function onClickButtons(event:MouseEvent):void
		{
			var button:UIButton = event.currentTarget as UIButton;
			if(_flash.hasOwnProperty(button.label.text)){
				var result:* = _flash[button.label.text]();
				
				if(result is CustomObject){
					trace(result.name, result.id);
				} else {
					trace(result);
				}
			}
		}
		
		protected function onClickButtonOff(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_flash.turnOn = false;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
		protected function onClickButtonOn(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_flash.turnOn = true;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
	
		protected function onClickButton(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_flash.brigthness = 1;
				_flash.turnOn = true;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
	}
}
*/