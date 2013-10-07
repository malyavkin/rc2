package {
    import com.am_devcorp.algo.game.control.FocusKeeper;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import gfx.*;
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Main extends Sprite {
        
        private var pics:Vector.<Vector.<Bitmap>>
        private var base:Sprite
        
        private var picWidth:uint
        private var picHeight:uint
        
        public function Main():void {
            var nHorz:uint;
            var nVert:uint;
            var hcaret:int;
            var vcaret:int;
            var sensor:Sprite;
            new Resources();
            picWidth = Resources.width;
            picHeight = Resources.height;
            base = new Sprite();
            
            base.x = -picWidth
            base.y = -picHeight
            
            pics = new Vector.<Vector.<Bitmap>>
            
            nHorz = Math.ceil(stage.stageWidth / picWidth) + 2
            nVert = Math.ceil(stage.stageHeight / picHeight) + 2
            
            vcaret = 0
            
            for (var i:int = 0; i < nVert; i++) {
                var picsRow:Vector.<Bitmap> = new Vector.<Bitmap>
                var string:Sprite = new Sprite()
                hcaret = 0
                for (var j:int = 0; j < nHorz; j++) {
                    var np:Bitmap
                    var selected:uint = Math.round(Math.random() * 3)
                    np = new Bitmap(Resources.getTextureFor(selected))
                    np.x = hcaret
                    np.y = vcaret
                    hcaret += np.width
                    picsRow.push(np)
                    base.addChild(np)
                    
                }
                vcaret = base.height
                pics.push(picsRow)
                
            }
            
            sensor = new Sprite();
            sensor.graphics.beginFill(0, 0);
            sensor.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            sensor.graphics.endFill();
            
            addChild(base)
            addChild(sensor)
            
            sensor.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
            sensor.addEventListener(MouseEvent.MOUSE_UP, onSensorMouseUp);
            sensor.addEventListener(MouseEvent.MOUSE_MOVE, onSensorMouseMove)
            addEventListener(Event.ENTER_FRAME, onEnterFrame)
            pics[0][0].bitmapData = LayeredTile.texture(Resources.SAND,Resources.RAILCROSS)
        }
        
        private function onEnterFrame(e:Event):void {
            base.x++
            base.y++
            onSensorMouseMove(null)
        }
        
        private function onSensorMouseUp(e:MouseEvent):void {
            base.stopDrag()
        
        }
        
        private function onMouseDown(e:MouseEvent):void {
            base.startDrag()
        }
        
        private function get rightExtra():int {
            return base.width - stage.stageWidth + base.x + pics[0][0].x
        }
        
        private function get leftExtra():int {
            return -base.x - pics[0][0].x
        }
        
        private function get botExtra():int {
            return base.height - stage.stageHeight + base.y + pics[0][0].y
        }
        
        private function get topExtra():int {
            return -base.y - pics[0][0].y
        }
        
        private function onSensorMouseMove(e:MouseEvent):void {
            if (rightExtra < picWidth / 2) {
                //add to right end
                var newx:int = pics[0][pics[0].length - 1].x + pics[0][pics[0].length - 1].width
                for (var i:int = 0; i < pics.length; i++) {
                    var bm:Bitmap = pics[i].shift()
                    bm.x = newx
                    pics[i].push(bm)
                    
                }
                
            } else if (leftExtra < picWidth / 2) {
                //add to left end
                for (var i:int = 0; i < pics.length; i++) {
                    var bm:Bitmap = pics[i].pop()
                    bm.x = pics[i][0].x - bm.width
                    pics[i].unshift(bm)
                }
            }
            
            if (botExtra < picHeight / 2) {
                //add to bot end
                var newy:int = pics[pics.length - 1][0].y + pics[pics.length - 1][0].height
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                //var str:Vector.<Bitmap> = pics.shift()
                pics.push(pics.shift())
                trace_ys()
                
            } else if (topExtra < picHeight / 2) {
                //add to top end
                var newy:int = pics[0][0].y - pics[pics.length - 1][0].height
                pics.unshift(pics.pop())
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                
            }
            
            function trace_ys():void {
                
                var s:String = ""
                for (var j:int = 0; j < pics.length; j++) {
                    s += pics[j][0].y + "  "
                }
                trace(newy, s)
            }
        
        }
    
    }

}