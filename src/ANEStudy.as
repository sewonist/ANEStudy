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
			
			_flash = new FlashLight;
			_flash.addEventListener(Event.CHANGE, onChange);
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