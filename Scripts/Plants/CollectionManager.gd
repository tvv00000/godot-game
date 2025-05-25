extends Node
@export var plants: Array[Resource] = []

#discover new plant
func discover_plant(plant_name: String) -> void:
	for plant in plants:
		if plant.name == plant_name and not plant.is_discovered:
			plant.is_discovered = true
			print("Discovered:", plant_name)
			break

#collect new plant
func collect_plant(plant_name: String) -> void:
	for plant in plants:
		if plant.name == plant_name and not plant.is_collected:
			plant.is_collected = true
			plant.is_discovered = true
			print("Collected:", plant_name)
			break

#check isCollected
func is_plant_collected(plant_name: String) -> bool:
	for plant in plants:
		if plant.name == plant_name:
			return plant.is_collected
	return false

#returns array of plants where is_discovered = true.
func get_discovered_plants() -> Array:
	return plants.filter(func(p): return p.is_discovered)

#returns array of plants where is_collected = true.
func get_collected_plants() -> Array:
	return plants.filter(func(p): return p.is_collected)

#loads and adds all files in "res://Scripts/Plants/Plants/"
func _ready():
	print("Loading Plants")
	var dir = DirAccess.open("res://Scripts/Plants/Plants/")
	if dir:
		for file_name in dir.get_files():
			print("Found file:", file_name)

			var original_file := file_name

			# remove .remap that is made when exporting
			if file_name.ends_with(".remap"):
				original_file = file_name.replace(".remap", "")

			if original_file.ends_with(".tres"):
				var plant_path = "res://Scripts/Plants/Plants/" + original_file
				var plant = load(plant_path)

				if plant:
					plants.append(plant)
					print("Loaded plant:", plant.name)
				else:
					print("Failed to load!!!!!!!!!!!!:", plant_path)
	else:
		print("Directory err")

	print("Total plants:", plants.size())
