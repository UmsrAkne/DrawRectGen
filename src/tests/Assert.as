package tests {
	/**
	 * ...
	 * @author 
	 */
	public final class Assert {
		
		private static var testCounter:int;
		
		public function Assert() {
			
		}
		
		public static function areEqual(a:*, b:*):void{
			if (a != b) throw Error(a + " != " + b);
			testCounter++;
		}
		
		public static function isTrue(value:Boolean):void{
			if (!value) throw Error("value is false");
			testCounter++;
		}

		public static function isFalse(value:Boolean):void{
			if (value) throw Error("value is true");
			testCounter++;
		}

		public static function get TestCounter():int{ return testCounter; }
	}
}