package app {

    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class DrawRectGenerator {

        private var bitmapData:BitmapData;
        private var preCheckRanges:Vector.<Rectangle>;
        private var loopCounter:int = 0;
        private var interval:int = 0;

        public function get LoopCounter():int {
            return loopCounter;
        }

        public function get Interval():int {
            return interval;
        }

        /**
         * bitmapdDataのピクセルを調査する際、Intervalの値に応じて調査するピクセルをスキップします。
         * デフォルトは0となっており、全ピクセルを調べます。
         * ex Interval = 1; ピクセルを一つ飛ばしで調べます。
         * @param value 負の値をセットしようとした場合には 0 がセットされます。
         */
        public function set Interval(value:int):void {
            if (value < 0) {
                value = 0;
                return;
            }
            interval = value;
        }

        /**
         *
         * @param bmpData 不透明な範囲を調べたい BitmapData を入力します。
         * @param optionCheckRanges 不透明範囲の候補がある場合は入力します。
         * このパラメーターを入力した場合は、この範囲を優先してチェックします。
         */
        public function DrawRectGenerator(bmpData:BitmapData, optionCheckRanges:Vector.<Rectangle> = null) {
            this.bitmapData = bmpData;

            if (optionCheckRanges) {
                this.preCheckRanges = optionCheckRanges;
            }
        }

        /**
         * 入力されたBitmapDataから完全に透明な部分を除いた範囲を矩形で取得します。
         * 注意:このメソッドで得た範囲内に透明ピクセルを含む場合はあり得ます。
         * 不透明部分が矩形以外の形である場合や、透明ピクセルが不透明ピクセルで囲まれている場合です。
         * このような場合、透明ピクセルが入る余地があることに注意してください。
         * @param bitmap 透明ピクセルを含むbitmapを入力します
         * @return
         */
        public function getDrawRect():Rectangle {
            var rect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
            var checkRect:Rectangle = rect.clone();

            rect.top += measureDistanceFromTop(rect);
            rect.left += measureDistanceFromLeft(rect);
            rect.right -= measureDistanceFromRight(rect);
            rect.bottom -= measureDistanceFromBottom(rect);

            return rect;
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
            for (var i:int = 0; i < pixelsLength; i += 1 + Interval) {
                if (i > Interval && i % bmpSize.width <= Interval) {
                    distance++;
                }

                if (pixels[i] > 0x00ffffff) {
                    break;
                }

                loopCounter++;
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

                checkingPoint.y += Interval + 1;
                if (checkingPoint.y > checkRange.bottom) {
                    checkingPoint.x += direction;
                    checkingPoint.y = checkRange.top;
                    if (!checkRange.contains(checkingPoint.x, checkingPoint.y)) {
                        break;
                    }

                    distance++;
                }

                loopCounter++
            }
            return distance;
        }

        public function measureDistanceFromBottom(checkRange:Rectangle):int {
            var distance:int = 0;
            var pixels:Vector.<uint> = bitmapData.getVector(checkRange);
            pixels.fixed = true;

            for (var i:int = pixels.length - 1; i >= 0; i -= 1 + Interval) {
                //ベクターの最後尾、checkRange の右下から左方向に向かって要素を調べる
                if (!isTransparentPixel(pixels[i])) {
                    break;
                }

                if (i != 0 && i % checkRange.width <= Interval) {
                    distance++;
                }

                loopCounter++;
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

        public function containsUntransparentPixel(rect:Rectangle):Boolean {
            var pxs:Vector.<uint> = bitmapData.getVector(rect);
            return pxs.some(function(item:uint, idx:int, v:Vector.<uint>):Boolean {
                return (item != 0x0);
            });
        }
