
var Countdown = (function () {
	
	var intervalHandle;
	var secondsRemaining;
	
	var _countMinute;
	var _endCallback;
	var _viewDivId;
	var _inputYn;
	
	function tick()
	{
		var minutes = Math.floor(secondsRemaining / 60);
		var seconds = secondsRemaining - (minutes * 60);

		if ( seconds < 10 )
		{
			seconds = "0" + seconds;
		}

		var remainTime = minutes.toString() + ":" + seconds;

		// console.log("[Countdown Check Remain Time] " + remainTime);

		if ( _viewDivId )
		{
			var viewDiv = document.getElementById(_viewDivId);

			if ( viewDiv )
			{
				if( _inputYn && _inputYn == 'Y' ) {
					viewDiv.value = remainTime;
				} else {
					viewDiv.innerHTML = remainTime;
				}
			}
		}


		if ( secondsRemaining === 0 )
		{
			clearInterval(intervalHandle);

			if ( typeof _endCallback === "function")
			{
				_endCallback();
			}
		}

		secondsRemaining--;
	}
	
	return {
		
		start : function(countMinute, endCallback, viewDivId, inputYn) {
			
			_countMinute = countMinute;
			_endCallback = endCallback;
			_viewDivId = viewDivId;
			_inputYn = inputYn;
			
			secondsRemaining = countMinute * 60;
			
			intervalHandle = setInterval(tick, 1000);
		},
	
		init : function() {
			
			secondsRemaining = _countMinute * 60;
		},
		
		stop : function(viewDivId, inputYn) {
			clearInterval(intervalHandle);
			if ( viewDivId )
			{
				var viewDiv = document.getElementById(viewDivId);
				
				if ( viewDiv )
				{
					if( inputYn && inputYn == 'Y' ) {
						viewDiv.value = ''
					} else {
						viewDiv.innerHTML = '';
					}
				}
			}
		}
	};
	
})();
