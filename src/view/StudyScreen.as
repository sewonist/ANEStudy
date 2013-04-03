package view
{
	import com.itpointlab.ane.FlashLight;
	
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
		
		public function StudyScreen()
		{
			super();
			
			_flashLight = new FlashLight;
			
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
				{label:'isSupport', callback:onClickSupport }
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
			
		}
	}
}