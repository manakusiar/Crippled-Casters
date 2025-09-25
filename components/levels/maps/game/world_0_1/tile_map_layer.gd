extends TileMapLayer

@export var scenes_source_id: int = 1

func _ready() -> void:
	fill_empty_spaces_under_tiles()

func fill_empty_spaces_under_tiles() -> void:
	if not tile_set:
		return

	var scenes_source = tile_set.get_source(scenes_source_id)
	if not scenes_source or not scenes_source is TileSetScenesCollectionSource:
		return

	var num_scenes = scenes_source.get_scene_tiles_count()
	if num_scenes == 0:
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var used_cells = get_used_cells()
	for cell in used_cells:
		
		var below_coords = Vector2i(cell.x, cell.y + 1)
		var below_atlas_coords = get_cell_atlas_coords(Vector2i(below_coords.x,below_coords.y))
		if below_atlas_coords.y == 2 and below_atlas_coords.x <= 5 and rng.randi()%100 > 70:
			var random_scene_index = rng.randi() % num_scenes + 1
			set_cell(below_coords, scenes_source_id, Vector2i(0, 0), random_scene_index)
			
	queue_redraw()
