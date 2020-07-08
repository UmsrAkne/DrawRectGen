package tests {

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import app.DrawRectGenerator;

    public class TestDrawRectGenerator {
        public function TestDrawRectGenerator() {
            test();
        }

        private function test():void {
            var bitmapData:BitmapData = new BitmapData(20, 20, true, 0x00ffffff);

            var drawRect:Rectangle = new Rectangle(5, 5, 5, 5);
            bitmapData.fillRect(drawRect, 0xffffffff);

            var drawRectGen:DrawRectGenerator = new DrawRectGenerator(bitmapData);
            var bmpRect:Rectangle = new Rectangle(0, 0, 20, 20);

            Assert.areEqual(drawRectGen.measureDistanceFromTop(bmpRect), 5);
            Assert.areEqual(drawRectGen.measureDistanceFromLeft(bmpRect), 5);
            Assert.areEqual(drawRectGen.measureDistanceFromRight(bmpRect), 10);
        }
    }
}
