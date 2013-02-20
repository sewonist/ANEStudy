package
{
	import com.danielfreeman.madcomponents.UIButton;
	import com.itpointlab.ane.FlashLight;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF(frameRate="60")]
	public class ANEStudy extends Sprite
	{
		private var _flash:FlashLight;
		private var _on:Boolean = false;
		private var _button:UIButton;
		private var _button2:UIButton;
		private var _dummy:Object;
		private var _button3:UIButton;
		
		public function ANEStudy()
		{
			super();
			
			_dummy = {x:1};
			
			_button = new UIButton(this, 120, 0, "Turn ON 100%");
			_button.scaleX = 2;
			_button.scaleY = 2;
			_button.addEventListener(MouseEvent.CLICK, onClickButton);
			
			_button2 = new UIButton(this, 120, 100, "Turn ON 50%");
			_button2.scaleX = 2;
			_button2.scaleY = 2;
			_button2.addEventListener(MouseEvent.CLICK, onClickButton2);
			
			_button3 = new UIButton(this, 120, 200, "Turn OFF");
			_button3.scaleX = 2;
			_button3.scaleY = 2;
			_button3.addEventListener(MouseEvent.CLICK, onClickButton3);
			
			_flash = new FlashLight;
			
		}
		
		protected function onClickButton3(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_flash.turnOn = false;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
		protected function onClickButton2(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_flash.brigthness = .5;
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