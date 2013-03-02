package view
{
	import com.itpointlab.ane.CustomObject;
	import com.itpointlab.ane.FlashLight;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.layout.VerticalLayout;
	
	import model.FlashLightProxy;
	
	import starling.events.Event;
	
	public class StudyScreen extends Screen
	{
		private var _flashLight:FlashLight;
		private var _container:ScrollContainer;
		
		public function StudyScreen()
		{
			super();
			
			_flashLight = FlashLightProxy.instance.flashLight;
		}
		
		override protected function initialize():void
		{
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			vLayout.gap = 20 * Constants.SCALE;
			vLayout.paddingTop = vLayout.paddingBottom = 16 * Constants.SCALE;
			vLayout.paddingLeft = 50 * Constants.SCALE;
			
			_container = new ScrollContainer;
			_container.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
			_container.layout = vLayout;
			_container.width = actualWidth;
			_container.height = actualHeight;
			
			addChild(_container);
			
			var buttonData:Array = [
				{label:'getBoolean', callback:onClickButtons },
				{label:'getInt', callback:onClickButtons },
				{label:'getString', callback:onClickButtons },
				{label:'getArray', callback:onClickButtons },
				{label:'getCustomObject', callback:onClickButtons },
				{label:'Turn ON', callback:onClickButtonOn },
				{label:'Turn OFF', callback:onClickButtonOff },
				{label:'SUM', callback:onClickButtonSum }
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
		
		protected function onClickButtons(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			if(_flashLight.hasOwnProperty(button.label)){
				var result:* = _flashLight[button.label]();
				
				if(result is CustomObject){
					trace(result.name, result.id);
				} else {
					trace(result);
				}
			}
		}
		
		protected function onClickButtonOff(event:Event):void
		{
			if(_flashLight.isSupported){
				_flashLight.turnOn = false;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
		protected function onClickButtonOn(event:Event):void
		{
			if(_flashLight.isSupported){
				_flashLight.turnOn = true;
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
		protected function onClickButtonSum(event:Event):void
		{
			if(_flashLight.isSupported){
				_flashLight.nativeSum('Steve Jobs', 1234567890);
			} else {
				trace("FlashLight is not supproted.");
			}
		}
		
	}
}