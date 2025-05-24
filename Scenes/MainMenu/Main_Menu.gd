extends Control

func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")

func _on_Settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainSettings.tscn")

func _on_Exit_pressed() -> void:
	get_tree().quit()
