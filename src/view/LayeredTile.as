package view {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import raster.*;
    
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class LayeredTile extends Sprite{
        
        public function LayeredTile(...layers) {
            super()
            for each (var l:uint in layers) {
                this.addChild(new Bitmap(Resources.getTextureFor(l)))
            }
            
            
            
        }
        public function change(...layers):void {
            while (this.numChildren) {
                this.removeChildAt(0)
            }
            for each (var l:uint in layers) {
                this.addChild(new Bitmap(Resources.getTextureFor(l)))
            }
        }
    }

}