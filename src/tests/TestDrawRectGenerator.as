package tests {

    import flash.display.BitmapData;

    public class TestDrawRectGenerator {
        public function TestDrawRectGenerator() {
            test();
        }

        private function test():void {
            var bitmapData:BitmapData = new BitmapData(800, 600, true, 0x000000);
            Assert.areEqual(bitmapData.transparent, true);
        }
    }
}
