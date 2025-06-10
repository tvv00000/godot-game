extends Control

func _ready():
	$".".hide()

func showMap():
	$".".show()

func _on_europe_btn_pressed():
	print("Europe button pressed")
	get_tree().change_scene_to_file("res://Scenes/Levels/Europe/Europe.tscn")
	$".".hide()

func _on_aed_btn_pressed() -> void:
	print("Garden button pressed")
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")
	$".".hide()
