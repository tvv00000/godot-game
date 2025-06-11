extends Control
signal map_open
signal map_closed


#Hideib kaardi kui mäng launchib
func _ready():
	hide()

#Avab hidden kaardi kui interactid pausimenüüs või mängusisese kaardiga
func showMap():
	$".".show()
	emit_signal("map_open")
	print("map shown")

func _on_europe_btn_pressed():
	emit_signal("map_closed")
	get_tree().paused = false
	print("Europe button pressed")
	get_tree().change_scene_to_file("res://Scenes/Levels/Europe/Europe.tscn")
	$".".hide()

func _on_aed_btn_pressed() -> void:
	emit_signal("map_closed")
	get_tree().paused = false
	print("Garden button pressed")
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")
	$".".hide()
