package model {
    import com.am_devcorp.algo.graphics.UIntPoint;
    import gfx.Resources;
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Level {
        public var size:UIntPoint
        public var world:Vector.<Vector.<WorldTile>>
        public function create(size:UIntPoint):void {
            this.size = size;
            world = new Vector.<Vector.<WorldTile>>
            for (var i:int = 0; i < size.i; i++) {
                var a:Vector.<WorldTile>=new Vector.<WorldTile>
                for (var j:int = 0; j < size.j; j++) {
                    a.push(new WorldTile(Resources.SAND))
                }
                world.push(a)
            }
            
        }
        public function load():void {
            trace("fu")
        }
        
    }

}