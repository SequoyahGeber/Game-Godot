extends TileMapLayer # Or whatever your main script extends

# --- Configuration ---
# Reference to the TileMap node (Assign in Inspector or use $Path/To/TileMap)
@export var tile_map: TileMapLayer = $/Layer1

# Layer index to modify
@export var target_layer: int = 0

# Map parameters
@export var map_width: int = 50
@export var map_height: int = 30
@export var map_origin: Vector2i = Vector2i(0, 0) # Top-left corner in TileMap coords

# Tile IDs (Get these from your TileSet editor!)
const GRASS_SOURCE_ID = 0
const GRASS_ATLAS_COORDS = Vector2i(2, 1) # Example

const DIRT_SOURCE_ID = 0
const DIRT_ATLAS_COORDS = Vector2i(3, 1) # Example

# --- Generation Logic ---

func _ready():
	if tile_map == null:
		printerr("TileMap node reference not set!")
		return
	generate_simple_random_map()

# Example: Simple random placement
func generate_simple_random_map():
	print("Generating simple random map...")
	# Clear existing tiles in the area first (optional)
	# clear_map_area(target_layer, map_origin, Vector2i(map_width, map_height))

	for y in range(map_height):
		for x in range(map_width):
			# Calculate the world grid coordinate
			var current_coords = map_origin + Vector2i(x, y)

			# Decide which tile to place (simple random example)
			var random_value = randf() # Random float between 0.0 and 1.0

			var source_id_to_use: int
			var atlas_coords_to_use: Vector2i

			if random_value < 0.6: # 60% chance of grass
				source_id_to_use = GRASS_SOURCE_ID
				atlas_coords_to_use = GRASS_ATLAS_COORDS
			else: # 40% chance of dirt
				source_id_to_use = DIRT_SOURCE_ID
				atlas_coords_to_use = DIRT_ATLAS_COORDS

			# --- Place the tile ---
			tile_map.set_cell(target_layer, current_coords, source_id_to_use, atlas_coords_to_use)

	# Optional: Force the TileMap to update its visuals immediately if needed,
	# though changes usually appear automatically.
	# tile_map.update_internals()
	print("Map generation complete.")


# Helper function to clear an area (useful before generating)
func clear_map_area(layer: int, origin: Vector2i, size: Vector2i):
	#print(f"Clearing map area on layer {layer} from {origin} size {size}")
	for y in range(size.y):
		for x in range(size.x):
			var coords = origin + Vector2i(x, y)
			# Setting source_id to -1 removes the tile
			tile_map.set_cell(layer, coords, -1)

# --- How to Trigger Generation (Relating to your previous question) ---

# You could call generate_simple_random_map() or a similar function
# when the player reaches certain intervals.

# Assuming you have the signal connection from the Player script as before:
func _on_player_y_interval_crossed(interval_index: int):
	#print(f"MainGame received signal: Player is now in Y interval {interval_index}")

	# Example: Generate a new chunk of map ahead of the player
	# Calculate where the new chunk should be based on interval_index
	# Note: Player position is global_position (pixels), need to convert to tile coords
	var player_pos_tile_coords = tile_map.local_to_map(tile_map.to_local(player_node.global_position))

	# Define the origin for the next chunk based on player position or interval
	# This logic needs careful design based on your game's needs
	var new_chunk_origin_y = (interval_index + 1) * 20 # Example: Generate 20 tiles high chunk ahead
	var new_chunk_origin = Vector2i(map_origin.x, new_chunk_origin_y) # Keep X the same for now

	generate_chunk(new_chunk_origin, Vector2i(map_width, 20)) # Generate a chunk 20 tiles high


# More modular generation function
func generate_chunk(origin: Vector2i, size: Vector2i):
	#print(f"Generating chunk at {origin} with size {size}")
	# You'd likely use a more sophisticated algorithm here (noise, etc.)
	# For this example, just reuse the simple random logic for the specific chunk
	for y in range(size.y):
		for x in range(size.x):
			var current_coords = origin + Vector2i(x, y)
			var random_value = randf()
			var source_id_to_use = DIRT_SOURCE_ID
			var atlas_coords_to_use = DIRT_ATLAS_COORDS

			if random_value < 0.6:
				source_id_to_use = GRASS_SOURCE_ID
				atlas_coords_to_use = GRASS_ATLAS_COORDS
			else:
				source_id_to_use = DIRT_SOURCE_ID
				atlas_coords_to_use = DIRT_ATLAS_COORDS

			tile_map.set_cell(target_layer, current_coords, source_id_to_use, atlas_coords_to_use)

	print("Chunk generation complete.")

# Need a reference to the player if triggering based on player position
@export var player_node: Node2D # Assign in inspector
