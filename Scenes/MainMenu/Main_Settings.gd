extends Control



func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")


func _on_button_2_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_button_pressed() -> void:
	OS.alert('Pole veel', 'alert')
