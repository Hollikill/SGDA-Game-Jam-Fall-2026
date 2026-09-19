extends Node
#################################
# Global settings

const screen_size = Vector2i(1280,720)

#################################
# Handles room transitions

enum EnterSide {LEFT, RIGHT, TOP, BOTTOM, CENTER}

var scene_transition_info = {
	entrance_side = EnterSide.CENTER,
	version_id = 0,
	player_position = Vector2(0,0),
}
#################################
# Handles unlocked anomalies
var room_data = {};
var room_versions = {};
var current_loaded_room: String = "";
var loading_rooms: bool = true;

func subscribe_anomaly_version(version_id: int):
	if (!room_versions.has(current_loaded_room)): room_versions[current_loaded_room] = [];
	if (room_versions[current_loaded_room].find(version_id) == -1):
		room_versions[current_loaded_room].append(version_id);

func _add_used_anomaly_version(room_id: String, version_id: int):
	if (!room_data.has(room_id)): room_data[room_id] = {};
	if (!room_data[room_id].has("used_versions")): room_data[room_id]["used_versions"] = [];
	if (room_data[room_id]["used_versions"].find(version_id) == -1):
		room_data[room_id]["used_versions"].append(version_id);

# build all the anomaly connections and versions into one map
func build_room_map():
	var room_paths = DirAccess.get_files_at("res://Scenes/Rooms")
	for path in room_paths:
		if !path.ends_with(".tscn"): continue;
		var packed_scene = load("res://Scenes/Rooms/"+path) as PackedScene;
		var room = packed_scene.instantiate();
		current_loaded_room = room.room_id;
		# get all connections to see which anomaly versions are used
		var entrance_sides = [room.top, room.bottom, room.left, room.right];
		for entrance_data in entrance_sides:
			if entrance_data == null: continue;
			_add_used_anomaly_version(entrance_data.room_id, entrance_data.version_id)
		# get all the anomaly versions of a room that exist
		subscribe_anomaly_version(0)
		for node in room.find_children("*", "AnomalyVersion", true, false):
			if node.anomaly_version >= 0:
				subscribe_anomaly_version(node.anomaly_version);
		room.free()
	#print("room_data:")
	#print(room_data)
	#print("room_versions:")
	#print(room_versions)

# in game functions
func complete_anomaly():
	if (!room_data.has(current_loaded_room)): room_data[current_loaded_room] = {};
	if (!room_data[current_loaded_room].has("completed_versions")): room_data[current_loaded_room]["completed_versions"] = [];
	if (room_data[current_loaded_room]["completed_versions"].find(scene_transition_info.version_id) == -1):
		room_data[current_loaded_room]["completed_versions"].append(scene_transition_info.version_id);

func is_complete(room_id: String):
	if (!room_data.has(room_id)): room_data[room_id] = {};
	if (!room_data[room_id].has("used_versions")): room_data[room_id]["used_versions"] = [];
	if (!room_data[room_id].has("completed_versions")): room_data[room_id]["completed_versions"] = [];
	return room_data[room_id]["completed_versions"].size()+1 >= room_data[room_id]["used_versions"].size();

#################################
func _ready() -> void:
	build_room_map();
	loading_rooms = false;
	pass
