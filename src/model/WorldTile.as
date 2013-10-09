package model {
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class WorldTile {
        public var ground:uint;
        public var mods:Array
        
        public function WorldTile(ground:uint,...mods) {
            this.ground = ground;
            this.mods = mods?mods:[];
            
        }
        
    }

}