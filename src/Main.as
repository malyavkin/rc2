package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import gfx.*;
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Main extends Sprite {
        
        
        
        public function Main():void {
            new Resources();
            var f:Field = new Field(500, 200)
            f.x = 150
            f.y = 200
            addChild(f)
            f.init()
            
            
            
        }
        
        
    
    }

}