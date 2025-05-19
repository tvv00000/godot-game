extends StaticBody3D

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactName: String = ""

func onInteract():
	print("interact toimib")
	
