package {
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import tests.Tester;

    /**
     * ...
     * @author
     */
    public class Main extends Sprite {

        public function Main() {
            var tester:Tester = new Tester();

            addEventListener(KeyboardEvent.KEY_DOWN, debugKeyboardEvent);
            stage.focus = this;
        }

        private function debugKeyboardEvent(e:KeyboardEvent):void {
            if (e.keyCode == Keyboard.Q) {
                NativeApplication.nativeApplication.exit();
            }
        }
    }

}
