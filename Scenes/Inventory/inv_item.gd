extends Resource

class_name InvItem 

@export var name: String = ""
@export var texture: Texture2D

func use():
	print("Item used: ", name)
