package tests {

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import app.DrawRectGenerator;

    public class TestDrawRectGenerator {
        public function TestDrawRectGenerator() {
            test();
        }

        private function test():void {
            var bitmapData:BitmapData = new BitmapData(800, 600, true, 0x00ffffff);

            var drawRect:Rectangle = new Rectangle(50, 100, 150, 200);
            bitmapData.fillRect(drawRect, 0xffffffff);

            var drawRectGen:DrawRectGenerator = new DrawRectGenerator(bitmapData);
            var bmpRect:Rectangle = new Rectangle(0, 0, 800, 600);

            Assert.areEqual(drawRectGen.measureDistanceFromTop(bmpRect), 100);
            Assert.areEqual(drawRectGen.measureDistanceFromLeft(bmpRect), 50);
        }
    }
}
