package tests {

    /**
     * ...
     * @author
     */
    public final class Assert {

        private static var testCounter:int;

        public function Assert() {

        }

        public static function areEqual(a:*, b:*, comment:String = ""):void {
            if (a != b) {
                issueTestFailureMessage("[Assert]" + " \t" + a + " != " + b, comment);
            }
            testCounter++;
        }

        public static function isTrue(value:Boolean, comment:String = ""):void {
            if (!value) {
                issueTestFailureMessage("[Assert]" + "\t" + "value is False", comment);
            }
            testCounter++;
        }

        public static function isFalse(value:Boolean, comment:String = ""):void {
            if (value) {
                issueTestFailureMessage("[Assert]" + "\t" + "value is True", comment);
            }
            testCounter++;
        }

        public static function get TestCounter():int {
            return testCounter;
        }

        private static function issueTestFailureMessage(msg:String, comment:String):void {
            trace("[Assert] テスト失敗 " + comment);
            trace(msg);
            trace("[Assert]" + " ========================================");
        }
    }
}
