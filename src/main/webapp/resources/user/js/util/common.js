
function isMobile() {
	
	var filter = "win16|win32|win64|linux";
	
	if(navigator.platform) {
		
		if(filter.indexOf( navigator.platform.toLowerCase()) < 0) {
			//mobile
			return true;
		}
	}
	
	return false;
}
