extends Resource

class_name InvItem 

@export var name: String = ""
@export var texture: Texture2D
@export var description: String = ""

func use():
	print("Item used: ", name)
	if Engine.has_singleton("UIAlert"):
		UiAlert.show_alert("Used item: " + name)
