package controller {
    import com.am_devcorp.algo.graphics.UIntPoint;
    import flash.events.Event;
    import model.WorldTile;
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class WorldEvent extends Event {
        public static const TILE:String = "tile"
        public static const WORLD:String = "world"
        public var updatedTile:UIntPoint
        public var datapiece:WorldTile
        public function WorldEvent(type:String = WORLD,x:uint=0,y:uint=0) { 
            super(type);
            updatedTile = new UIntPoint(x,y)
        } 
        
    }
    
}