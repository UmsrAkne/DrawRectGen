package app {

    import flash.geom.Rectangle;
    import flash.display.BitmapData;

    public class DrawRectGenerator {

        private var bitmapData:BitmapData;

        public function DrawRectGenerator(bmpData:BitmapData) {
            this.bitmapData = bmpData;
        }

        /**
         * 入力されたBitmapDataから完全に透明な部分を除いた範囲を矩形で取得します。
         * 注意:このメソッドで得た範囲内に透明ピクセルを含む場合はあり得ます。
         * 不透明部分が矩形以外の形である場合や、透明ピクセルが不透明ピクセルで囲まれている場合です。
         * このような場合、透明ピクセルが入る余地があることに注意してください。
         * @param bitmap 透明ピクセルを含むbitmapを入力します
         * @return
         */
        public static function get(bitmapData:BitmapData):Rectangle {
            var rect:Rectangle = new Rectangle();

            return rect;
        }
    }
}
