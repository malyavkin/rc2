package {
    
    import flash.display.Sprite;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import model.*;
    import view.*;
    import controller.*;
    import raster.*;
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Main extends Sprite {
        
        
        
        public function Main():void {
            new Resources();
            var w:World = new World();
            w.create(4,4);
            var e:Engine = new Engine(w)
            
            var f:Field = new Field(640, 480);
            f.init(e);
            
            addChild(f);
            f.addEventListener(MouseEvent.CLICK, onFClick)
            e.start();
            this.stage.scaleMode = StageScaleMode.NO_SCALE
        }
        
        private function onFClick(e:MouseEvent):void {
            trace(e.target.mouseX, e.target.mouseY)
        }
        
        
    
    }

}