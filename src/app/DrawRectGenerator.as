package app {

    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.Point;

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
        public function getDrawRect(bitmapData:BitmapData):Rectangle {
            return new Rectangle;
        }

        /**
         * bitmapDataの不透明ピクセルが存在する不透明領域とbitmapDataの天辺との距離を取得します
         */
        public function measureDistanceFromTop(checkRange:Rectangle):int {
            var distance:int = 0;
            var bmpSize:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);

            var pixels:Vector.<uint> = bitmapData.getVector(bmpSize);
            pixels.fixed = true;

            var pixelsLength:int = pixels.length;

            // top を判定
            for (var i:int = 0; i < pixelsLength; i++) {
                if (i != 0 && i % bmpSize.width == 0) {
                    distance++;
                }

                if (pixels[i] > 0x00ffffff) {
                    break;
                }
            }

            return distance;
        }

        public function measureDistanceFromLeft(checkRange:Rectangle):int {
            return measureDistanceFromSide(checkRange, "fromLeft");
        }

        public function measureDistanceFromRight(checkRange:Rectangle):int {
            return measureDistanceFromSide(checkRange, "fromRight");
        }

        /**
         * bitmapDataの不透明ピクセルが存在する領域とbitmapDataの左端との距離を取得します。
         * @param checkRange
         * @return
         */
        private function measureDistanceFromSide(checkRange:Rectangle, searchDirection:String):int {
            var distance:int = 0;
            var checkingPoint:Point;
            var direction:int = 1;

            if (searchDirection == "fromLeft") {
                checkingPoint = checkRange.topLeft;
                direction = 1;
            }

            if (searchDirection == "fromRight") {
                // pixcelの位置情報はゼロオリジン
                // 例えば幅 10px の画像ならばピクセルのインデックスは 0-9
                // -1 しておかないと w=10 のrectangleの右端を指定した場合、読み取り開始位置が x=10 となりズレる。
                checkingPoint = new Point(checkRange.right - 1, checkRange.top);
                direction = -1;
            }

            var loopCount:int = checkRange.width * checkRange.height;
            for (var i:int = 0; i < loopCount; i++) {
                if (!isTransparentPixel(bitmapData.getPixel32(checkingPoint.x, checkingPoint.y))) {
                    break;
                }

                checkingPoint.y++;
                if (checkingPoint.y > checkRange.bottom) {
                    checkingPoint.x += direction;
                    checkingPoint.y = 0;
                    if (!checkRange.contains(checkingPoint.x, checkingPoint.y)) {
                        break;
                    }

                    distance++;
                }
            }
            return distance;
        }

        /**
         * 入力されたピクセルが完全な透明ピクセルかどうかを判定します。
         * @param pixelValue
         * @return
         */
        private function isTransparentPixel(pixelValue:uint):Boolean {
            return pixelValue <= 0x00ffffff;
        }
    }
}
