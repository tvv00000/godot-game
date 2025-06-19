extends Resource

class_name InvItem 

@export var id: String
@export var name: String = ""
@export var texture: Texture2D
@export var description: String = ""

func _onready():
	Global.inv_item = self

func use(target = null):
	if name == "item_muld":
		if target and target.planterState == 0:
			target.planterState = 1
			print("Muld lisatud potti")
			var slot_index = Global.inv_ui.current_slot
			if slot_index >= 0:
				Global.inv_ui.inv.use_item(slot_index)

			if Global.player:
				var current_quest = Global.player.selected_quest
				if current_quest:
					Global.player.update_quest_tracker(current_quest)
					print("2222222222222222222222222222222222", current_quest.name)
				else:
					print("No selected quest")
	print("Item used: ", name)
