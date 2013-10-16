package controller {
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import model.*;
	/**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    [Event(name="tile", type="controller.WorldEvent")]
    [Event(name="world", type="controller.WorldEvent")]
    public class Engine extends EventDispatcher{
        public var w:World
        
        
        public var t:Timer  = new Timer(50)
        public function Engine(w:World) {
            this.w = w
        }
        public function start():void {
            broadcast_global_update()
        }
        
        private function broadcast_global_update():void {
            dispatchEvent(new WorldEvent())
        }
        public function stop():void {
            
        }
        
        // INTERACTION WITH VIEWS
        public function add():void {
            
        }
        public function remove(i:uint,j:uint):void {
            
        }
        
        //INTERACTION WITH MODEL
        
    }

}