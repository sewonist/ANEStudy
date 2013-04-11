package view
{
	import com.itpointlab.ane.FlashLight;
	import com.itpointlab.ane.adpopcornextension.AdPOPcornExtension;
	import com.itpointlab.ane.adpopcornextension.RewardServerType;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class StudyScreen extends Screen
	{
		private var _container:ScrollContainer;
		
		private var _flashLight:FlashLight;
		private var _adpopcorn:AdPOPcornExtension;
		
		public function StudyScreen()
		{
			super();
			
			_flashLight = new FlashLight;
			_adpopcorn = new AdPOPcornExtension;
			_adpopcorn.initAdPOPcorn( "N1975969617", "a8c94bd3e36c4f09", "testUser", RewardServerType.AdPopcornRewardServerTypeClient );
		}
		
		override protected function initialize():void
		{
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			vLayout.gap = 20 * Constants.SCALE;
			vLayout.paddingTop = vLayout.paddingBottom = 16 * Constants.SCALE;
			vLayout.paddingLeft = 15 * Constants.SCALE;
			
			_container = new ScrollContainer;
			_container.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
			_container.layout = vLayout;
			_container.width = actualWidth;
			_container.height = actualHeight;
			
			addChild(_container);
			
			var buttonData:Array = [
				{label:'isSupport', callback:onClickSupport },
				{label:'light on', callback:onClickLightOn},
				{label:'light off', callback:onClickLightOff },
				{label:'showOfferwall', callback:onClickShowOfferwall }
			];
			
			for each(var data:Object in buttonData){
				var button:Button = factoryButton(data.label, data.callback);
				_container.addChild(button);
			}
			
			super.initialize();
		}
		override protected function draw():void
		{
			_container.width = actualWidth;
			_container.height = actualHeight ;
			
			super.draw();
		}
		private function factoryButton(label:String, callback:Function):Button
		{
			var button:Button = new Button;
			button.label = label;
			button.addEventListener(Event.TRIGGERED, callback);
			
			return button;
		}
		protected function onClickSupport(event:Event):void
		{
			trace( '_flashLight.isSupported : ', _flashLight.isSupported );
		}
		protected function onClickLightOn(event:Event):void
		{
			_flashLight.turnOn = true;
		}
		protected function onClickLightOff(event:Event):void
		{
			_flashLight.turnOn = false;
		}
		protected function onClickShowOfferwall(event:Event):void
		{
			_adpopcorn.showOfferwall();
		}
		
	}
}