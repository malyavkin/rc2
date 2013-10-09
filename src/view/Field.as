package view {
    import com.am_devcorp.algo.graphics.UIntPoint;
    import controller.*;
    import model.WorldTile;
    import raster.*;
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
        
        //drawable
        private var base:Sprite
        private var basemask:Sprite
        private var sensor:Sprite;
        
        //size of a tile
        private var picWidth:uint;
        private var picHeight:uint;
        
        private var pics:Vector.<Vector.<LayeredTile>>
        //number of rendering tiles
        private var nHorz:uint;
        private var nVert:uint;
        
        private var updateTimer:Timer;
        
        //«pure» sizes, w/o invisible parts
        private var virtual_width:uint
        private var virtual_height:uint
        
        //camera
        private var cam_x:int
        private var cam_y:int
        
        //directions 
        private const TOP:uint = 0
        private const RIGHT:uint = 1
        private const BOT:uint = 2
        private const LEFT:uint = 3
        
        private var engine:Engine
        
        public function Field(width:uint, height:uint):void {
            super()
            new Resources();
            
            //THINGS
            virtual_width = width
            virtual_height = height
            picWidth = Resources.width;
            picHeight = Resources.height;
            pics = new Vector.<Vector.<LayeredTile>>
            nHorz = Math.ceil(virtual_width / picWidth) + 2
            nVert = Math.ceil(virtual_height / picHeight) + 2
            trace(nHorz, nVert)
            updateTimer = new Timer(20)
            updateTimer.addEventListener(TimerEvent.TIMER, infinite)
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
            basemask.graphics.beginFill(0xffffff, 0.5);
            basemask.graphics.drawRect(0, 0, width, height);
            basemask.graphics.endFill();
            
            //ADD THEM
            addChild(base)
            addChild(basemask)
            addChild(sensor)
            base.mask = basemask;
        }
        
        public function init(e:Engine):void {
            this.engine = e
            e.addEventListener(WorldEvent.TILE, onETile)
            e.addEventListener(WorldEvent.WORLD, onEWorld);
            cam_x = 0
            cam_y = 0
            
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
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            pics[0][0].change(Resources.SAND, Resources.RAILCROSS)
            updateTimer.start()
        }
        
        private function onEWorld(e:WorldEvent):void {
            for (var i:int = 0; i < pics.length; i++) {
                for (var j:int = 0; j < pics[i].length; j++) {
                    var coords:UIntPoint = view_to_model_coords(j, i);
                    var wt:WorldTile = engine.w.data[coords.i][coords.j];
                    
                    draw(i, j, wt)
                    
                }
            }
            trace("world updated")
        }
        
        private function onETile(e:WorldEvent):void {
            for (var i:int = 0; i < pics.length; i++) {
                for (var j:int = 0; j < pics[i].length; j++) {
                    var coords:UIntPoint = view_to_model_coords(j, i);
                    if (coords.x == e.updatedTile.x && coords.y == e.updatedTile.y) {
                        draw(i, j, e.datapiece)
                    }
                    
                }
            }
        
        }
        
        private function draw(i:uint, j:uint, wt:WorldTile):void {
            if (wt.mods.length) {
                
                pics[i][j].change(wt.ground, wt.mods[0])
            } else {
                
                pics[i][j].change(wt.ground)
            }
        }
        
        private function view_to_model_coords(viewX:int, viewY:int):UIntPoint {
            var rx = (viewX + cam_x)
            while (rx < 0) {
                rx += engine.w.size.x
            }
            rx %= engine.w.size.x
            
            var ry = (viewY + cam_y)
            while (ry < 0) {
                ry += engine.w.size.y
            }
            ry %= engine.w.size.y
            
            return new UIntPoint(rx, ry)
        }
        
        private function infinite(a:Event):void {
            while (rightExtra < picWidth / 2) {
                trace("→")
                var newx:int = pics[0][pics[0].length - 1].x + pics[0][pics[0].length - 1].width;
                for (var i:int = 0; i < pics.length; i++) {
                    pics[i][0].x = newx
                    pics[i].push(pics[i].shift())
                    
                }
                cam_x++
                redraw_partial(RIGHT)
                
            }
            while (leftExtra < picWidth / 2) {
                trace("←")
                //add to left end
                for (var i:int = 0; i < pics.length; i++) {
                    var bm:LayeredTile = pics[i].pop()
                    bm.x = pics[i][0].x - bm.width
                    pics[i].unshift(bm)
                }
                cam_x--
                redraw_partial(LEFT)
            }
            
            while (botExtra < picHeight / 2) {
                //add to bot end
                trace("↓")
                
                var newy:int = pics[pics.length - 1][0].y + pics[pics.length - 1][0].height
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                //var str:Vector.<Bitmap> = pics.shift()
                pics.push(pics.shift())
                
                cam_y++
                redraw_partial(BOT)
                
            }
            while (topExtra < picHeight / 2) {
                //add to top end
                trace("↑")
                var newy:int = pics[0][0].y - pics[pics.length - 1][0].height
                pics.unshift(pics.pop())
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                cam_y--
                redraw_partial(TOP)
            }
        }
        
        private function redraw_partial(dir:uint):void {
            switch (dir) {
                case TOP:
                    var i:int = 0
                    for (var j:int = 0; j < pics[0].length; j++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                case RIGHT:
                    var j:int = pics[0].length - 1
                    for (var i:int = 0; i < pics.length; i++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                case BOT:
                    var i:int = pics.length - 1
                    for (var j:int = 0; j < pics[0].length; j++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                case LEFT:
                    var j:int = 0
                    for (var i:int = 0; i < pics.length; i++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                default:
            }
        }
        
        private function get rightExtra():int {
            return base.width - virtual_width + base.x + pics[0][0].x
        }
        
        private function get leftExtra():int {
            return -base.x - pics[0][0].x
        }
        
        private function get botExtra():int {
            return base.height - virtual_height + base.y + pics[0][0].y
        }
        
        private function get topExtra():int {
            return -base.y - pics[0][0].y
        }
        
        private function onEnterFrame(e:Event):void {
            base.x++
            base.y++
        }
        
        private function onMouseDown(e:MouseEvent):void {
            base.startDrag()
        }
        
        private function onSensorMouseUp(e:MouseEvent):void {
            base.stopDrag()
        }
        
        override public function get width():Number {
            return virtual_width
        }
        
        override public function get height():Number {
            return virtual_height
        }
    
    }

}