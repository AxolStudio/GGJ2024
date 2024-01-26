

class Background (

	enum GenType {
		Default
	}

	var tile_center: Tile;
	var tile_left:   Tile;
	var tile_right:  Tile;
	var tile_up:     Tile;
	var tile_down:   Tile;
	
	public function shift_left() {
		tile_left   = tile_center;
		tile_center = tile_right;
		tile_right  = Tile.Generate();
	}
	
	public function shift_right() {
		tile_right  = tile_center;
		tile_center = tile_left;
		tile_left   = Tile.Generate();
	}
	
	public function shift_up() {
		tile_up     = tile_center;
		tile_center = tile_down;
		tile_down   = Tile.Generate();
	}
	
	public function shift_down() {
		tile_down   = tile_center;
		tile_center = tile_up;
		tile_up     = Tile.Generate();
	}
	
	public function new() {
		
	}

	static public function Generate(genType:GenType) {
		var newBackground: new Background();
		
		newBackground.tile_center = Tile.Generate(Tile.GenType.Ocean);
		newBackground.tile_left   = Tile.Generate(Tile.GenType.Ocean);
		newBackground.tile_right  = Tile.Generate(Tile.GenType.Ocean);
		newBackground.tile_up     = Tile.Generate(Tile.GenType.Ocean);
		newBackground.tile_down   = Tile.Generate(Tile.GenType.Ocean);
		
		return newBackground;
	}
)