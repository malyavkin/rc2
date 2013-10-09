package gfx {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Field extends Sprite {
        
        private var base:Sprite
        private var basemask:Sprite
        private var sensor:Sprite;
        
        private var picWidth:uint;
        private var picHeight:uint;
        
        private var pics:Vector.<Vector.<LayeredTile>>
        private var nHorz:uint;
        private var nVert:uint;
        
        public function Field(width:uint, height:uint):void {
            super()
            new Resources();
            //THINGS
            picWidth = Resources.width;
            picHeight = Resources.height;
            pics = new Vector.<Vector.<LayeredTile>>
            nHorz = Math.ceil(width/ picWidth) + 2
            nVert = Math.ceil(height/ picHeight) + 2
            trace(nHorz, nVert)
            var updateTimer:Timer = new Timer(50)
            //updateTimer.addEventListener(TimerEvent.TIMER)

            //BASE
            base = new Sprite();
            base.x = -picWidth
            base.y = -picHeight
            
            //SENSOR
            sensor = new Sprite();
            sensor.graphics.beginFill(0, 0);
            sensor.graphics.drawRect(0, 0, width, height);
            sensor.graphics.endFill();
            //BASEMASK
            basemask = new Sprite();
            basemask.graphics.beginFill(0xffffff,1);
            basemask.graphics.drawRect(0, 0, width, height);
            basemask.graphics.endFill();
            
            //ADD THEM
            addChild(base)
            addChild(sensor)
            addChild(basemask)
            base.mask = basemask;
        }
        
        public function init() {
            var hcaret:int;
            var vcaret:int;
            
            vcaret = 0
            
            for (var i:int = 0; i < nVert; i++) {
                var picsRow:Vector.<LayeredTile> = new Vector.<LayeredTile>
                hcaret = 0
                for (var j:int = 0; j < nHorz; j++) {
                    var np:LayeredTile
                    var selected:uint = Math.round(Math.random() * 3)
                    np = new LayeredTile(selected, Resources.RAILSTRAIGHT)
                    np.x = hcaret
                    np.y = vcaret
                    hcaret += np.width
                    picsRow.push(np)
                    base.addChild(np)
                    
                }
                vcaret = base.height
                pics.push(picsRow)
                
            }
            
            sensor.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
            sensor.addEventListener(MouseEvent.MOUSE_UP, onSensorMouseUp);
            sensor.addEventListener(MouseEvent.MOUSE_MOVE, onSensorMouseMove)
            addEventListener(MouseEvent.RIGHT_CLICK, function(a:Event):void {
                    removeEventListener(Event.ENTER_FRAME, onEnterFrame)
                })
            addEventListener(Event.ENTER_FRAME, onEnterFrame)
            pics[0][0].change(Resources.SAND, Resources.RAILCROSS)
        
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
        
        private function update():void {
            while (rightExtra < picWidth / 2) {
                trace(rightExtra)
                //add to right end
                var newx:int = pics[0][pics[0].length - 1].x + pics[0][pics[0].length - 1].width;
                for (var i:int = 0; i < pics.length; i++) {
                    pics[i][0].x = newx
                    pics[i].push(pics[i].shift())
                    
                }
                
            }
            while (leftExtra < picWidth / 2) {
                //add to left end
                for (var i:int = 0; i < pics.length; i++) {
                    var bm:LayeredTile = pics[i].pop()
                    bm.x = pics[i][0].x - bm.width
                    pics[i].unshift(bm)
                }
            }
            
            while (botExtra < picHeight / 2) {
                //add to bot end
                var newy:int = pics[pics.length - 1][0].y + pics[pics.length - 1][0].height
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                //var str:Vector.<Bitmap> = pics.shift()
                pics.push(pics.shift())
                
            }
            while (topExtra < picHeight / 2) {
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
        
        private function onEnterFrame(e:Event):void {
            base.x++
            base.y++
            onSensorMouseMove(null)
        }
        
        private function onMouseDown(e:MouseEvent):void {
            base.startDrag()
        }
        
        private function onSensorMouseUp(e:MouseEvent):void {
            base.stopDrag()
        }
        
        private function onSensorMouseMove(e:MouseEvent):void {
            update()
        }
    
    }

}