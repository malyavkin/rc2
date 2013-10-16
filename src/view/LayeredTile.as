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
    public class LayeredTile extends Sprite {
        private var picLayers:Sprite
        private var hover_frame:Sprite
        
        public function LayeredTile(... layers) {
            super()
            picLayers = new Sprite()
            hover_frame = new Sprite()
            addChild(picLayers)
            addChild(hover_frame)
            
            for each (var l:uint in layers) {
                picLayers.addChild(new Bitmap(Resources.getTextureFor(l)))
            }
        
        }
        
        public function set hover_effect(v:Boolean):void {
            if (v) {
                hover_frame.graphics.clear()
                hover_frame.graphics.lineStyle(2, 0xFFFFFF)
                hover_frame.graphics.beginFill(0, 0)
                hover_frame.graphics.drawRect(0, 0, this.width-1, this.height-1)
                hover_frame.graphics.endFill()
            } else {
                hover_frame.graphics.clear()
            }
        
        }
        
        public function change(... layers):void {
            picLayers.removeChildren()
            for each (var l:uint in layers) {
                picLayers.addChild(new Bitmap(Resources.getTextureFor(l)))
            }
        }
    }

}