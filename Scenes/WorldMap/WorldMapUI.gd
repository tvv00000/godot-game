extends Control

signal map_open
signal map_closed
@onready var Planters: Array[Node] = get_tree().get_nodes_in_group("Planter")

func _ready():
	hide()
	set_process_unhandled_input(true)
	
func showMap():
	show()
	emit_signal("map_open")
	print("map shown")

# ESC key handler
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			emit_signal("map_closed")
			get_tree().paused = false
			get_viewport().set_input_as_handled()

func _on_europe_btn_pressed():
	save_scene()
	emit_signal("map_closed")
	get_tree().paused = false
	print("Europe button pressed")
	Global.last_teleport_scene = "res://Scenes/Levels/Europe/Europe.tscn"
	get_tree().change_scene_to_file("res://Scenes/Levels/Europe/Europe.tscn")
	hide()
	Global.isGardenLevel = false

func _on_aed_btn_pressed() -> void:
	emit_signal("map_closed")
	get_tree().paused = false
	print("Garden button pressed")
	Global.last_teleport_scene = "res://Scenes/Levels/Europe/Garden.tscn"
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")
	load_scene()
	hide()
	Global.isGardenLevel = true
	
func save_scene(): 
	var data = SceneData.new()
	for planter in Planters:
		var planterScene = PackedScene.new()
		planterScene.pack(planter)
		data.planterArray.append(planterScene)
	ResourceSaver.save(data, "user://gardenData.tres")
	print("Saved garden state!")

func load_scene():
	var data = ResourceLoader.load("user://gardenData.tres")
	for planter in Planters:
		planter.queue_free()
	
	for planter in data.planterArray:
		var loaded_planter = planter.instantiate()
		#get_tree().get_root().get_node("../../Planters").add_child(loaded_planter)

	
