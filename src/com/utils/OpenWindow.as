package com.utils {
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class OpenWindow {
		
		private static var browserName:String = "";
		
		public static function open(url:String, window:String="_blank", features:String=""):void{
			
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			var myURL:URLRequest = new URLRequest(url);		
			
			if(browserName == ""){
				browserName = getBrowserName();
			}
			
			switch(getBrowserName())
			{
				case "Firefox":
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case "IE":
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case "Safari":
					navigateToURL(myURL, window);
					break;
				case "Opera":
					navigateToURL(myURL, window); 
					break;
				case "Undefined":
					navigateToURL(myURL, window);
					break;
			}
		}
		private static function getBrowserName():String{
			var browser:String;
			
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			
			if(browserAgent != null && browserAgent.indexOf("Firefox") >= 0) {
				browser = "Firefox";
			} 
			else if(browserAgent != null && browserAgent.indexOf("Safari") >= 0){
				browser = "Safari";
			}			 
			else if(browserAgent != null && browserAgent.indexOf("MSIE") >= 0){
				browser = "IE";
			}		 
			else if(browserAgent != null && browserAgent.indexOf("Opera") >= 0){
				browser = "Opera";
			}
			else {
				browser = "Undefined";
			}
			return browser;
		}
	}
}