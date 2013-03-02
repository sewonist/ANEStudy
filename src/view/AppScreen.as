package view
{
	import com.itpointlab.ane.FlashLight;
	
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.utils.Timer;
	
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.layout.AnchorLayoutData;
	
	import model.FlashLightProxy;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AppScreen extends Screen
	{
		private const SAMPLE_RATE:Number = 22050;	// Actual microphone sample rate (Hz)
		private const LOGN:uint = 6;				// Log2 FFT length
		private const N:uint = 1 << LOGN;			// FFT Length
		private const BUF_LEN:uint = N;				// Length of buffer for mic audio
		private const UPDATE_PERIOD:int = 50;		// Period of spectrum updates (ms)
		
		private var m_fft:FFT2;						// FFT object
		
		private var m_tempRe:Vector.<Number>;		// Temporary buffer - real part
		private var m_tempIm:Vector.<Number>;		// Temporary buffer - imaginary part
		private var m_mag:Array;			// Magnitudes (at each of the frequencies below)
		private var m_freq:Vector.<Number>;			// Frequencies (for each of the magnitudes above)
		private var m_win:Vector.<Number>;			// Analysis window (Hanning)
		
		private var m_mic:Microphone;				// Microphone object
		private var m_writePos:uint = 0;			// Position to write new audio from mic
		private var m_buf:Vector.<Number> = null;	// Buffer for mic audio
		
		private var m_tickTextAdded:Boolean = false;
		
		private var m_timer:Timer;					// Timer for updating spectrum
		private var _fft:Shape;
		private var _flashLight:FlashLight;
		private var _maxSlider:Slider;
		private var _max:Number = 0;
		private var _valueLabel:Label;
		private var _spectrum:Sprite;
		private var _oldAverage:Number;
		
		public function AppScreen()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			init();
			initFFT();
		}
		
		override protected function draw():void
		{
			//_maxSlider.y = actualHeight - _maxSlider.height * 2;
			
			super.draw();
		}
		
		private function init():void
		{
			
			_flashLight = FlashLightProxy.instance.flashLight;
			
			_maxSlider = new Slider;
			_maxSlider.minimum = 0;
			_maxSlider.maximum = 100;
			_maxSlider.value = 44;
			_maxSlider.addEventListener(Event.CHANGE, onChangeSlider);
			_maxSlider.step = 1;
			_maxSlider.page = 1;
			_maxSlider.direction = Slider.DIRECTION_HORIZONTAL;
			_maxSlider.liveDragging = true;
			addChild(_maxSlider);
			_max = -_maxSlider.value;
			
			_maxSlider.x = 10;
			_maxSlider.y = 382;
			
			_valueLabel = new Label();
			_valueLabel.text = _maxSlider.value.toString();
			addChild(_valueLabel);
			
			_valueLabel.x = _maxSlider.x + 120;
			_valueLabel.y = _maxSlider.y;
			
			_spectrum = new Sprite;
			addChild(_spectrum);
		}
		
		private function onChangeSlider(event:Event):void
		{
			_max = -_maxSlider.value;
			_valueLabel.text = _maxSlider.value.toString();
		}
		
		public function initFFT():void
		{
			_fft = new Shape;
			_spectrum.addChild(_fft);
			
			
			var i:uint;
			
			// Set up the FFT
			m_fft = new FFT2();
			m_fft.init(LOGN);
			m_tempRe = new Vector.<Number>(N);
			m_tempIm = new Vector.<Number>(N);
			//m_mag = new Vector.<Number>(N/2);
			m_mag = new Array();;
			//m_smoothMag = new Vector.<Number>(N/2);
			
			// Vector with frequencies for each bin number. Used
			// in the graphing code (not in the analysis itself).
			m_freq = new Vector.<Number>(N/2);
			for ( i = 0; i < N/2; i++ )
				m_freq[i] = i*SAMPLE_RATE/N;
			
			// Hanning analysis window
			m_win = new Vector.<Number>(N);
			for ( i = 0; i < N; i++ )
				m_win[i] = (4.0/N) * 0.5*(1-Math.cos(2*Math.PI*i/N));
			
			// Create a buffer for the input audio
			m_buf = new Vector.<Number>(BUF_LEN);
			for ( i = 0; i < BUF_LEN; i++ )
				m_buf[i] = 0.0;
			
			// Set up microphone input
			m_mic = Microphone.getMicrophone();
			m_mic.rate = SAMPLE_RATE/1000;
			m_mic.setSilenceLevel(0.0);			// Have the mic run non-stop, regardless of the input level
			m_mic.addEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );
			
			// Set up a timer to do periodic updates of the spectrum
			m_timer = new Timer(UPDATE_PERIOD);
			m_timer.addEventListener(TimerEvent.TIMER, updateSpectrum);
			m_timer.start();
		}
		
		/**
		 * Called whether new microphone input data is available. See this call
		 * above:
		 *    m_mic.addEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );
		 */
		private function onMicSampleData( event:SampleDataEvent ):void
		{
			// Get number of available input samples
			var len:uint = event.data.length/4;
			
			// Read the input data and stuff it into
			// the circular buffer
			for ( var i:uint = 0; i < len; i++ )
			{
				m_buf[m_writePos] = event.data.readFloat();
				
				//trace(m_buf[m_writePos]);
				
				m_writePos = (m_writePos+1)%BUF_LEN;
			}
		}
		
		/**
		 * Called at regular intervals to update the spectrum
		 */
		private function updateSpectrum( event:TimerEvent ):void
		{
			// Copy data from circular microphone audio
			// buffer into temporary buffer for FFT, while
			// applying Hanning window.
			var i:int;
			var pos:uint = m_writePos;
			for ( i = 0; i < N; i++ )
			{
				m_tempRe[i] = m_win[i]*m_buf[pos];
				pos = (pos+1)%BUF_LEN;
			}
			
			// Zero out the imaginary component
			for ( i = 0; i < N; i++ )
				m_tempIm[i] = 0.0;
			
			// Do FFT and get magnitude spectrum
			m_fft.run( m_tempRe, m_tempIm );
			for ( i = 0; i < N/2; i++ )
			{
				var re:Number = m_tempRe[i];
				var im:Number = m_tempIm[i];
				m_mag[i] = Math.sqrt(re*re + im*im);
			}
			
			// Convert to dB magnitude
			const SCALE:Number = 20/Math.LN10;
			for ( i = 0; i < N/2; i++ )
			{
				// 20 log10(mag) => 20/ln(10) ln(mag)
				// Addition of MIN_VALUE prevents log from returning minus infinity if mag is zero
				m_mag[i] = SCALE*Math.log( m_mag[i] + Number.MIN_VALUE );
			}
			
			checkMax();
			
			// Draw the graph
			//drawSpectrum( m_mag, m_freq );
			drawBackground( m_mag, m_freq );
		}
		
		
		private function checkAverage():void
		{
			var av:Number = average(m_mag[15],m_mag[16],m_mag[17],m_mag[18]);
			trace('average : ', av);
			if( av > -60 ){
				trace('--------------------------------> turn on');
				_flashLight.turnOn = true;
			} else {
				_flashLight.turnOn = false;
			}
		}
		
		private function checkMax():void
		{
			var max:Number = Math.max.apply(this, m_mag);
			//trace('max : ', max);
			if(max > _max){
				trace('--------------------------------> turn on');
				_flashLight.turnOn = true;
			} else {
				_flashLight.turnOn = false;
			}
		}
		
		private function average(... args):Number
		{
			var temp:Number = 0;
			for each ( var i:Number in args ){
				temp += i;
			}
			temp /= args.length;
			
			return temp;
		}
		
		private function drawBackground(m_mag:Array, m_freq:Vector.<Number>):void
		{
			// Basic constants
			const MIN_FREQ:Number = 0;					// Minimum frequency (Hz) on horizontal axis.
			const MAX_FREQ:Number = 10000;				// Maximum frequency (Hz) on horizontal axis.
			const FREQ_STEP:Number = 500;				// Interval between ticks (Hz) on horizontal axis.
			const MAX_DB:Number = -0.0;					// Maximum dB magnitude on vertical axis.
			const MIN_DB:Number = -60.0;				// Minimum dB magnitude on vertical axis.
			const DB_STEP:Number = 10;					// Interval between ticks (dB) on vertical axis.
			const TOP:Number  = 0;						// Top of graph
			const LEFT:Number = 0;						// Left edge of graph
			const HEIGHT:Number = 380;					// Height of graph
			const WIDTH:Number = 320;					// Width of graph
			const TICK_LEN:Number = 10;					// Length of tick in pixels
			const LABEL_X:String = "Frequency (Hz)";	// Label for X axis
			const LABEL_Y:String = "dB";				// Label for Y axis
			
			// Derived constants
			const BOTTOM:Number = TOP+HEIGHT;					// Bottom of graph
			const DBTOPIXEL:Number = HEIGHT/(MAX_DB-MIN_DB);	// Pixels/tick
			const FREQTOPIXEL:Number = WIDTH/(MAX_FREQ-MIN_FREQ);// Pixels/Hz
			
			
			_fft.graphics.clear();
			
			// Draw a rectangular box marking the boundaries of the graph
			///var av:Number = average.apply(this, m_mag) * -1;
			//var av:Number = average(m_mag[5]) * -1;
			//av = m_mag[8];
			
			var av:Number = BOTTOM - DBTOPIXEL*(m_mag[3]-MIN_DB);
			if ( av > BOTTOM )
				av = BOTTOM;
			
			if(!_oldAverage) _oldAverage = av;
			
			_fft.graphics.beginFill(Math.abs(_oldAverage - av)*0xFFFFFF);
			_fft.graphics.drawRect( LEFT, TOP, WIDTH, HEIGHT );
			_fft.graphics.endFill();
			
			_oldAverage = av;
		}
		
		
		/**
		 * Draw a graph of the spectrum
		 */
		private function drawSpectrum(
			mag:Array,
			freq:Vector.<Number> ):void
		{
			// Basic constants
			const MIN_FREQ:Number = 0;					// Minimum frequency (Hz) on horizontal axis.
			const MAX_FREQ:Number = 10000;				// Maximum frequency (Hz) on horizontal axis.
			const FREQ_STEP:Number = 500;				// Interval between ticks (Hz) on horizontal axis.
			const MAX_DB:Number = -0.0;					// Maximum dB magnitude on vertical axis.
			const MIN_DB:Number = -60.0;				// Minimum dB magnitude on vertical axis.
			const DB_STEP:Number = 10;					// Interval between ticks (dB) on vertical axis.
			const TOP:Number  = 10;						// Top of graph
			const LEFT:Number = 10;						// Left edge of graph
			const HEIGHT:Number = 300;					// Height of graph
			const WIDTH:Number = 300;					// Width of graph
			const TICK_LEN:Number = 10;					// Length of tick in pixels
			const LABEL_X:String = "Frequency (Hz)";	// Label for X axis
			const LABEL_Y:String = "dB";				// Label for Y axis
			
			// Derived constants
			const BOTTOM:Number = TOP+HEIGHT;					// Bottom of graph
			const DBTOPIXEL:Number = HEIGHT/(MAX_DB-MIN_DB);	// Pixels/tick
			const FREQTOPIXEL:Number = WIDTH/(MAX_FREQ-MIN_FREQ);// Pixels/Hz
			
			//-----------------------
			
			var i:uint;
			var numPoints:uint;
			
			numPoints = mag.length;
			//if ( mag.length != freq.length )
				//				trace( "mag.length != freq.length" );
				
			_fft.graphics.clear();
			
			// Draw a rectangular box marking the boundaries of the graph
			_fft.graphics.lineStyle( 1, 0x000000 );
			_fft.graphics.beginFill(0xDCDCDC);
			_fft.graphics.drawRect( LEFT, TOP, WIDTH, HEIGHT );
			_fft.graphics.moveTo(LEFT, TOP+HEIGHT);
			
			// -------------------------------------------------
			// The line in the graph
			
			// Ignore points that are too far to the left
			for ( i = 0; i < numPoints && freq[i] < MIN_FREQ; i++ )
			{
			}
			//trace('------- draw spectrum : ', numPoints ,' -----');
			// For all remaining points within range of x-axis
			var firstPoint:Boolean = true;
			for ( /**/; i < numPoints && freq[i] <= MAX_FREQ; i++ )
			{
				// Compute horizontal position
				x = LEFT + FREQTOPIXEL*(freq[i]-MIN_FREQ);
				
				// Compute vertical position of point
				// and clip at top/bottom.
				y = BOTTOM - DBTOPIXEL*(mag[i]-MIN_DB);
				if ( y < TOP )
					y = TOP;
				else if ( y > BOTTOM )
					y = BOTTOM;
				
				// If it's the first point
				if ( firstPoint )
				{
					// Move to the point
					_fft.graphics.moveTo(x,y);
					firstPoint = false;
				}
				else
				{
					// Otherwise, draw line from the previous point
					//					if(i == 1)trace(y);
					 _fft.graphics.lineTo(x,y);
					//trace('lineTo :', x, y);
				}
			}
			
			_fft.x = -310;
			_fft.y = -300;
		}
	}
}