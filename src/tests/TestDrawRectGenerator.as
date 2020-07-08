package tests {

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import app.DrawRectGenerator;

    public class TestDrawRectGenerator {
        public function TestDrawRectGenerator() {
            test();
            test2("左上に不透明領域が寄っている場合のテスト");
            test3("右下に不透明領域が寄っている場合のテスト");
        }

        private function test():void {
            var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);

            var drawRect:Rectangle = new Rectangle(5, 10, 15, 20);
            bitmapData.fillRect(drawRect, 0xffffffff);

            var drawRectGen:DrawRectGenerator = new DrawRectGenerator(bitmapData);
            var bmpRect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);

            // 画像の天辺から不透明領域の天辺までの距離
            Assert.areEqual(drawRectGen.measureDistanceFromTop(bmpRect), 10);

            // 画像の左端から不透明領域の右端までの距離
            Assert.areEqual(drawRectGen.measureDistanceFromLeft(bmpRect), 5);

            // 画像の右端から不透明領域の右端までの距離
            Assert.areEqual(drawRectGen.measureDistanceFromRight(bmpRect), 30);

            // 画像の底辺から不透明領域の底辺までの距離
            Assert.areEqual(drawRectGen.measureDistanceFromBottom(bmpRect), 20);

            Assert.isTrue(drawRect.equals(drawRectGen.getDrawRect()));
        }

        private function test2(comment:String):void {
            var bmd:BitmapData = new BitmapData(40, 40, true, 0x00ffffff);
            var drawRect:Rectangle = new Rectangle(0, 0, 15, 20);
            bmd.fillRect(drawRect, 0xffffffff);

            var bmdRect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
            var rectGen:DrawRectGenerator = new DrawRectGenerator(bmd);
            Assert.isTrue(drawRect.equals(rectGen.getDrawRect()));
        }

        private function test3(comment:String):void {
            var bmd:BitmapData = new BitmapData(40, 40, true, 0x00ffffff);
            var drawRect:Rectangle = new Rectangle(20, 20, 20, 20);
            bmd.fillRect(drawRect, 0xffffffff);

            var bmdRect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
            var rectGen:DrawRectGenerator = new DrawRectGenerator(bmd);
            Assert.isTrue(drawRect.equals(rectGen.getDrawRect()));
        }
    }
}
