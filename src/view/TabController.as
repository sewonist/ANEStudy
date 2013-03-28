package view
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.motion.transitions.TabBarSlideTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public class TabController extends Sprite
	{
		private static const APP_SCREEN:String = "appScreen";
		private static const STUDY_SCREEN:String = "studyScreen";
		
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _tabBar:TabBar;
		private var _transitionManager:TabBarSlideTransitionManager;
		
		public function TabController()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
		}
		
		private function onAddedStage(event:Event):void
		{
			stage.addEventListener(ResizeEvent.RESIZE, onResizeStage);
			
			_theme = new MetalWorksMobileTheme();
			
			_navigator = new ScreenNavigator();
			_navigator.addEventListener(Event.CHANGE, onChangeNavigator);
			addChild(_navigator);
			
			_navigator.addScreen(STUDY_SCREEN, new ScreenNavigatorItem(StudyScreen));
			
			_tabBar = new TabBar();
			_tabBar.addEventListener(Event.CHANGE, onChangeTabBar);
			addChild(_tabBar);
			_tabBar.dataProvider = new ListCollection(
				[
					{ label: "Study", action: STUDY_SCREEN }
				]);
			_tabBar.validate();
			layout(stage.stageWidth, stage.stageHeight);
			
			_navigator.showScreen(STUDY_SCREEN);
			
			_transitionManager = new TabBarSlideTransitionManager(_navigator, _tabBar);
			_transitionManager.duration = 0.4;
		}
		
		private function onChangeTabBar():void
		{
			_navigator.showScreen(_tabBar.selectedItem.action);
		}
		
		private function onChangeNavigator():void
		{
			const dataProvider:ListCollection = this._tabBar.dataProvider;
			const itemCount:int = dataProvider.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = dataProvider.getItemAt(i);
				if(this._navigator.activeScreenID == item.action)
				{
					this._tabBar.selectedIndex = i;
					break;
				}
			}
			
			_navigator.activeScreen.height = stage.stageHeight - _tabBar.height;
		}
		
		private function onResizeStage(event:ResizeEvent):void
		{
			layout(event.width, event.height);
		}
		
		private function layout(w:Number, h:Number):void
		{
			_tabBar.width = w;
			_tabBar.x = (w - _tabBar.width) / 2;
			_tabBar.y = h - _tabBar.height;
		}
	}
}