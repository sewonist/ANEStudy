package
{
	import com.danielfreeman.madcomponents.UIButton;
	import com.itpointlab.ane.FlashLight;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ANEStudy extends Sprite
	{
		private var _flash:FlashLight;
		private var _on:Boolean = false;
		private var _button:UIButton;
		
		public function ANEStudy()
		{
			super();
			
			_button = new UIButton(this, 240, 100, "Turn ON");
			_button.addEventListener(MouseEvent.CLICK, onClickButton);
			
			_flash = new FlashLight;
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