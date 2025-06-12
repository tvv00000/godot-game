extends Control

@onready var sfx_death = $sfx_death
@onready var label = $TextureRect/VBoxContainer/VBoxContainer/LossReason

func _ready():
	match Global.last_loss_reason:
		"drowned":
			sfx_death.play()
			label.text = "Eksmati uppus!!!! Appiiii!!!"
func _on_retry_btn_pressed() -> void:
	if Global.last_teleport_scene != "":
		print("Kreiiisii retry")
		get_tree().change_scene_to_file(Global.last_teleport_scene)
	else:
		print("You haven't teleported anywhere!!! How!!")
		get_tree().change_scene_to_file("res://Scenes/Levels/StartLevel.tscn")


func _on_give_up_btn_pressed() -> void:
	print("Returning!")
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
