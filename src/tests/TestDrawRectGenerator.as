package tests {

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import app.DrawRectGenerator;

    public class TestDrawRectGenerator {
        public function TestDrawRectGenerator() {
            test();
            test2("左上に不透明領域が寄っている場合のテスト");
            test3("右下に不透明領域が寄っている場合のテスト");
            test4("loop回数を確認するテスト");

            testContainsUnTransparentPixel();
            testExistUntransparentPixelOnOuterEdge();
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

            var v:Vector.<Rectangle> = new Vector.<Rectangle>();
            v.push(drawRect);
            var rectGen2:DrawRectGenerator = new DrawRectGenerator(bmd, v);
            Assert.isTrue(drawRect.equals(rectGen2.getDrawRect()));
        }

        private function test4(param0:String):void {
            var bmd:BitmapData = new BitmapData(40, 40, true, 0x0);
            var drawRect:Rectangle = new Rectangle(10, 10, 10, 10);
            bmd.fillRect(drawRect, 0xffffffff);

            var bmdRect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
            var rectGen:DrawRectGenerator = new DrawRectGenerator(bmd);
            rectGen.Interval = -1; // 負の数なら０がセットされる
            Assert.areEqual(rectGen.Interval, 0, "既定値0で試行");
            rectGen.getDrawRect();

            //  40 * 40 = 1600px の矩形のうち、
            //  不透明な領域が 10 * 10 = 100px 
            //  初回テストのループ回数は 1550 回前後　不透明領域の位置により微妙に変動
            Assert.isTrue(rectGen.LoopCounter > 1500, "本来は1500回以上ループする");

            var secondRectGen:DrawRectGenerator = new DrawRectGenerator(bmd);
            secondRectGen.Interval = 1;
            Assert.areEqual(secondRectGen.Interval, 1);
            secondRectGen.getDrawRect();
            Assert.isTrue(secondRectGen.LoopCounter < 800, "1600pxのうち、調査するピクセルを半分程度まで減らす");
            Assert.isTrue(drawRect.equals(secondRectGen.getDrawRect()), "取得する矩形は想定と同じか");

            var thridRectGen:DrawRectGenerator = new DrawRectGenerator(bmd);
            thridRectGen.Interval = 2;
            thridRectGen.getDrawRect();
            Assert.isTrue(thridRectGen.LoopCounter < 540, "1600pxのうち 調査ピクセルを3/1程度まで減らす")
            Assert.isTrue(drawRect.equals(thridRectGen.getDrawRect()), "取得する矩形は想定と同じか");
        }

        private function testContainsUnTransparentPixel():void {
            var bmd:BitmapData = new BitmapData(40, 40, true, 0x0);
            var drawRect:Rectangle = new Rectangle(10, 10, 10, 10);
            bmd.fillRect(drawRect, 0xffffffff);

            var bmdRect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);

            var ranges:Vector.<Rectangle> = new Vector.<Rectangle>();
            ranges.push(new Rectangle(5, 5, 13, 13));
            ranges.push(new Rectangle(30, 30, 20, 20));
            ranges.push(new Rectangle(10, 10, 10, 10));
            var rectGen:DrawRectGenerator = new DrawRectGenerator(bmd);

            Assert.isTrue(rectGen.containsUntransparentPixel(new Rectangle(10, 10, 10, 10)));
            Assert.isFalse(rectGen.containsUntransparentPixel(new Rectangle(30, 30, 10, 10)));

        }

        private function testExistUntransparentPixelOnOuterEdge():void {
            var bmd:BitmapData = new BitmapData(40, 40, true, 0x0);
            var drawRect:Rectangle = new Rectangle(10, 10, 10, 10);
            bmd.fillRect(drawRect, 0xffffffff);

            var bmdRect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);

            var ranges:Vector.<Rectangle> = new Vector.<Rectangle>();
            ranges.push(drawRect);
            var rectGen:DrawRectGenerator = new DrawRectGenerator(bmd);

            // drawRect の外縁には、不透明ピクセルが存在しないので false 
            // 精度を下げても結果は変わらないはず
            Assert.isFalse(rectGen.existUntransparentPixelOnOuterEdge(drawRect, 0));
            Assert.isFalse(rectGen.existUntransparentPixelOnOuterEdge(drawRect, 1));
            Assert.isFalse(rectGen.existUntransparentPixelOnOuterEdge(drawRect, 2));

            // 検索範囲を少し右にずらす。　不透明ピクセルがはみ出すはずなので true
            var r:Rectangle = new Rectangle(12, 10, 20, 20);
            Assert.isTrue(rectGen.existUntransparentPixelOnOuterEdge(r, 0));
        }
    }
}
