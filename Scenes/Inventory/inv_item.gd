extends Resource

class_name InvItem 

@export var name: String = ""
@export var texture: Texture2D
@export var description: String = ""

func use(target = null):
	if name == "Mullahunnik":
		if target and target.planterState == 0:
			target.planterState = 1
			target.dirtRatio = min(target.dirtRatio + 50, 100)
			print("Muld lisatud potti")
			var slot_index = Global.inv_ui.current_slot
			if slot_index >= 0:
				Global.inv_ui.inv.use_item(slot_index)
	print("Item used: ", name)
