package gfx {
    import flash.display.BitmapData;
    import flash.geom.Point;
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class LayeredTile {
        
        public function LayeredTile() {
            
        }
        public static function texture(...layers):BitmapData {
            var bd:BitmapData = new BitmapData(Resources.width, Resources.height)
            for each (var i in layers) {
                var src:BitmapData = Resources.getTextureFor(i)
                bd.copyPixels(src, src.rect, new Point(),null,new Point(),true)
                
            }
            return bd
        }
    }

}