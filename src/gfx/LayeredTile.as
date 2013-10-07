package gfx {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class LayeredTile extends Sprite{
        
        public function LayeredTile(...layers) {
            super()
            for each (var l in layers) {
                this.addChild(new Bitmap(Resources.getTextureFor(l)))
            }
        }
        
    }

}