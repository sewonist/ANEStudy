package model
{
	import com.itpointlab.ane.FlashLight;

	public class FlashLightProxy
	{
		private static var _instance:FlashLightProxy;
		private static var _singleton_lock:Boolean = false;
		
		private var _flashLight:FlashLight;
		
		public function FlashLightProxy() 
		{
			if ( !_singleton_lock ) throw new Error( 'Use Singleton.instance' );
			
			_flashLight = new FlashLight;
		}
		
		public function set instance(instance:FlashLightProxy):void 
		{
			throw new Error('Singleton.instance is read-only');
		}
		
		public static function get instance():FlashLightProxy 
		{
			if ( _instance == null )
			{
				_singleton_lock = true;
				_instance = new FlashLightProxy();
				_singleton_lock = false;
			}
			return _instance;
		}
		
		public function get flashLight():FlashLight
		{
			return _flashLight;
		}
	}
}


