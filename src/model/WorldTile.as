package model {
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class WorldTile {
        public var ground:uint;
        public var mods:Vector.<uint>;
        
        public function WorldTile(ground:uint,mods:Vector.<uint>=null) {
            this.ground = ground;
            this.mods = mods;
            
        }
        
    }

}