extends Node

var planter_data: Dictionary = {}

func save_game():
	planter_data.clear()
	for planter in get_tree().get_nodes_in_group("Planter"):
		planter_data[planter.planter_id] = planter.get_save_data()

	var save_dict = {
		"planters": planter_data
	}

	var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	file.close()
	print("Saving data:", JSON.stringify(save_dict, "\t"))

func load_game():
	if not FileAccess.file_exists("user://save_data.json"):
		print("No save file found.")
		return

	var file = FileAccess.open("user://save_data.json", FileAccess.READ)
	var content = file.get_as_text()
	var save_dict = JSON.parse_string(content)

	if save_dict.has("planters"):
		for planter in get_tree().get_nodes_in_group("Planter"):
			var id = planter.planter_id
			if save_dict["planters"].has(id):
				planter.load_data(save_dict["planters"][id])
