extends Area3D

#see lihtsalt saadab labeli upstreami
@onready var InteractLabel: Label3D = $InteractLabel


#script mida panna main objekti külge:
#@onready var Interactable: Area3D = $Interactable
#@export var interactName: String = ""
#
#func _ready() -> void:
	##interactable scriptis interacatable skripti algus
	#pass
	#
#func onInteract():
	#print("interact toimib")
	#Collision: pea objektil layer 1/2, mask 1. Interactables mask 2, layer tühi.
