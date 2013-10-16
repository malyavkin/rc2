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
    import flash.utils.getTimer
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Field extends Sprite {
        
        //directions 
        private const TOP:uint = 0
        private const RIGHT:uint = 1
        private const BOT:uint = 2
        private const LEFT:uint = 3
        
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
        
        //camera
        private var cam_x:int
        private var cam_y:int
        
        //timers-related
        private var updateTimer:Timer;
        private var last_mouseDownTime:uint
        private var maxShortClickDuration:uint = 175 //empirically chosen value
        
        /// OVERRIDES
        
        //«pure» sizes, w/o invisible parts
        private var virtual_width:uint
        private var virtual_height:uint
        
        //mousex in tiles, not pixels
        private var virtual_mousex:uint
        private var virtual_mousey:uint
        
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
                    np = new LayeredTile(Resources.SAND)
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
            sensor.addEventListener(MouseEvent.MOUSE_MOVE, onSensorMouseMove);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(MouseEvent.CLICK, onClick);
            
            pics[0][0].change(Resources.SAND, Resources.RAILCROSS)
            updateTimer.start()
        }
        
        // need to stop Sprite native click events
        private function onClick(e:MouseEvent):void {
            e.stopImmediatePropagation()
        }
        
        private function onMouseDown(e:MouseEvent):void {
            base.startDrag()
            last_mouseDownTime = getTimer()
        }
        
        private function onSensorMouseUp(e:MouseEvent):void {
            base.stopDrag()
            if (last_mouseDownTime + maxShortClickDuration >= getTimer()) {
                //is a shortclick  
                trace(mouseX, mouseY)
                dispatchEvent(new MouseEvent(MouseEvent.CLICK))
            }
        }
        
        // finding which tile touches the mouse
        private function onSensorMouseMove(e:MouseEvent):void {
            var virtual_mousex_copy:uint = virtual_mousex
            var virtual_mousey_copy:uint = virtual_mousey
            
            virtual_mousex = uint((e.target.mouseX + leftExtra) / this.picWidth)
            virtual_mousey = uint((e.target.mouseY + topExtra) / this.picHeight)
            
            if (virtual_mousex_copy != virtual_mousex || virtual_mousey_copy != virtual_mousey) {
                // changed
                pics[virtual_mousey_copy][virtual_mousex_copy].hover_effect = false
                pics[virtual_mousey][virtual_mousex].hover_effect = true
            }
        
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
            var rx:int = (viewX + cam_x)
            while (rx < 0) {
                rx += engine.w.size.x
            }
            rx %= engine.w.size.x
            
            var ry:int = (viewY + cam_y)
            while (ry < 0) {
                ry += engine.w.size.y
            }
            ry %= engine.w.size.y
            
            return new UIntPoint(rx, ry)
        }
        
        private function infinite(a:Event):void {
            var newx:int
            var newy:int
            while (rightExtra < picWidth / 2) {
                //add to right end
                newx = pics[0][pics[0].length - 1].x + pics[0][pics[0].length - 1].width;
                for (var i:int = 0; i < pics.length; i++) {
                    pics[i][0].x = newx
                    pics[i].push(pics[i].shift())
                }
                cam_x++
                redraw_partial(RIGHT)
                
            }
            while (leftExtra < picWidth / 2) {
                //add to left end
                newx = pics[0][0].x - pics[0][pics[0].length-1].width
                for (var i:int = 0; i < pics.length; i++) {
                    var bm:LayeredTile = pics[i].pop()
                    bm.x = newx
                    pics[i].unshift(bm)
                }
                cam_x--
                redraw_partial(LEFT)
            }
            
            while (botExtra < picHeight / 2) {
                //add to bot end
                newy = pics[pics.length - 1][0].y + pics[pics.length - 1][0].height
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                pics.push(pics.shift())
                cam_y++
                redraw_partial(BOT)
            }
            while (topExtra < picHeight / 2) {
                //add to top end
                newy = pics[0][0].y - pics[pics.length - 1][0].height
                pics.unshift(pics.pop())
                for (var i:int = 0; i < pics[0].length; i++) {
                    pics[0][i].y = newy
                }
                cam_y--
                redraw_partial(TOP)
            }
        }
        
        private function redraw_partial(dir:uint):void {
            var i:uint
            var j:uint
            
            switch (dir) {
                case TOP:  {
                    i = 0
                    for (j = 0; j < pics[0].length; j++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                }
                
                case RIGHT:  {
                    j = pics[0].length - 1
                    for (i = 0; i < pics.length; i++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    
                    break;
                }
                case BOT:  {
                    i = pics.length - 1
                    for (j = 0; j < pics[0].length; j++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                }
                case LEFT:  {
                    j = 0
                    for (i = 0; i < pics.length; i++) {
                        var coords:UIntPoint = view_to_model_coords(j, i);
                        draw(i, j, engine.w.data[coords.i][coords.j])
                    }
                    break;
                }
                default:
            }
        }
        
        /// PROPERTIES    
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
            //base.x++
            //base.y++
        }
        
        /// OVERRIDES
        override public function get width():Number {
            return virtual_width
        }
        
        override public function get height():Number {
            return virtual_height
        }
        
        override public function get mouseX():Number {
            return virtual_mousex
        }
        
        override public function get mouseY():Number {
            return virtual_mousey
        }
    
    }

}