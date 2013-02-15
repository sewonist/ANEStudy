package
{
	import com.danielfreeman.madcomponents.UIButton;
	import com.greensock.TweenLite;
	import com.itpointlab.ane.FlashLight;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ANEStudy extends Sprite
	{
		private var _flash:FlashLight;
		private var _on:Boolean = false;
		private var _button:UIButton;
		private var _button2:UIButton;
		private var _dummy:Object;
		
		public function ANEStudy()
		{
			super();
			
			_dummy = {x:1};
			
			_button = new UIButton(this, 120, 100, "Turn ON");
			_button.scaleX = 2;
			_button.scaleY = 2;
			_button.addEventListener(MouseEvent.CLICK, onClickButton);
			
			_button2 = new UIButton(this, 120, 240, "Vibrate ON");
			_button2.scaleX = 2;
			_button2.scaleY = 2;
			_button2.addEventListener(MouseEvent.CLICK, onClickVibrate);
			
			_flash = new FlashLight;
		}
		
		protected function onClickVibrate(event:MouseEvent):void
		{
			if(_flash.isSupported){
				vibrate();
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
		private function vibrate():void
		{
			_flash.turnVibrateOn();
			_dummy.x = 1;
			TweenLite.to(_dummy, 1, {x:100, onComplete:vibrate} );
		}
		
		protected function onClickButton(event:MouseEvent):void
		{
			if(_flash.isSupported){
				_on = !_on;
				_flash.turnLightOn( _on );
			} else {
				trace("FlashLight is not supproted.");
			}
		}
	}
}