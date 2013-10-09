package model {
    import raster.Resources;
    import com.am_devcorp.algo.graphics.UIntPoint;
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class World {
        public var size:UIntPoint
        public var data:Vector.<Vector.<WorldTile>>
        public function create(width:uint,height:uint):void {
            this.size = new UIntPoint(width,height)
            data = new Vector.<Vector.<WorldTile>>
            for (var i:int = 0; i < size.i; i++) {
                var a:Vector.<WorldTile>=new Vector.<WorldTile>
                for (var j:int = 0; j < size.j; j++) {
                    a.push(new WorldTile(Resources.SAND))
                }
                data.push(a)
            }
            data[0][0]=new WorldTile(Resources.SOULSAND,Resources.RAILSTRAIGHT)
            data[2][2]=new WorldTile(Resources.OBSIDIAN,Resources.RAILCROSS)
        }
        public function load():void {
            trace("fu")
        }
        
    }

}