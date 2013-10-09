package raster {
    import flash.display.BitmapData;
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    public class Resources {

        [Embed(source="textures/bg/sand.png")]
        private static const bgSand:Class
        [Embed(source ="textures/bg/obsidian.png")]
        private static const bgObsidian:Class
        [Embed(source="textures/bg/netherrack.png")]
        private static const bgNetherrack:Class
        [Embed(source="textures/bg/soul_sand.png")]
        private static const bgSoulSand:Class
        
        [Embed(source="textures/rail/0.png")]
        private static const rail0:Class
        [Embed(source="textures/rail/1.png")]
        private static const rail1:Class
        [Embed(source="textures/rail/3.png")]
        private static const rail3:Class

        public static const SAND         :uint = 0
        public static const OBSIDIAN     :uint = 1
        public static const NETHERRACK   :uint = 2
        public static const SOULSAND     :uint = 3
        public static const RAILCROSS    :uint = 4
        public static const RAILSTRAIGHT :uint = 5
        public static const RAILTURN     :uint = 6
        private static var bdatas:Vector.<BitmapData>;
        
        public function Resources() {
            bdatas = new Vector.<BitmapData>
            bdatas.push(new bgSand().bitmapData,
                        new bgObsidian().bitmapData,
                        new bgNetherrack().bitmapData,
                        new bgSoulSand().bitmapData,
                        new rail0().bitmapData,
                        new rail1().bitmapData,
                        new rail3().bitmapData)
        }
        
        public static function getTextureFor(type:uint,ver:uint =0):BitmapData {
            return bdatas[type]
        }
        
        static public function get width():uint {
            return bdatas[0].width;
        }
        
        static public function get height():uint {
            return bdatas[0].height;
        }
        
    }

}