extends Control

signal map_open
signal map_closed

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
	emit_signal("map_closed")
	get_tree().paused = false
	print("Europe button pressed")
	Global.last_teleported_scene = "res://Scenes/Levels/Europe/Europe.tscn"
	get_tree().change_scene_to_file("res://Scenes/Levels/Europe/Europe.tscn")
	hide()

func _on_aed_btn_pressed() -> void:
	emit_signal("map_closed")
	get_tree().paused = false
	print("Garden button pressed")
	Global.last_teleported_scene = "res://Scenes/Levels/Europe/Garden.tscn"
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")
	hide()
