extends StaticBody3D
@onready var Interactable: Area3D = $Interactable
@export var interactLabel: String = "Reisi Maailmas"

func _ready() -> void:
	#interactable scriptis interacatable skripti algus
	pass
	
func onInteract():
	get_tree().change_scene_to_file("res://Scenes/Levels/Europe/Europe.tscn")
