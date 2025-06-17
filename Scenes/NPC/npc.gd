extends StaticBody3D

@onready var dialog_manager = $DialogManager
@export var spriteTexture: Resource
@export var npc_id: String
@export var npc_name: String
@export var interactLabel: String = "Alusta Vestlust"
var current_state = "start"
var current_branch_index = 0
var dialogs = {}

@export var dialog_resource: Dialog
@export var quests: Array[Quest] = []
var quest_manager: Node = null

func _ready():
	# Load dialog data 
	#Ta teeb seda nüüd oma npc failist
	#load_from_json("res://Resources/Dialog/dialog_{0}.json".format([npc_id]))
	dialog_resource.load_from_json("res://Resources/Dialog/dialog_data.json")
	# Initialize npc ref
	dialog_manager.npc = self
	$Pivot/Sprite.set_texture(spriteTexture)
	# Get quest manager
	quest_manager = Global.player.quest_manager
	print("NPC Ready. Quests loaded: ", quests.size())
	

func start_dialog():
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id)
	if npc_dialogs.is_empty():
		return
	dialog_manager.show_dialog(self)

# Get current branch dialog
func  get_current_dialog():
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id) 
	if current_branch_index < npc_dialogs.size():
		for dialog in npc_dialogs[current_branch_index]["dialogs"]:
			if dialog["state"] == current_state:
				return dialog
	return null

# Update dialog branch
func set_dialog_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

# Update dialog state
func set_dialog_state(state):
	current_state = state
	
# Offer quest at required branch
func offer_quest(quest_id: String):
	print("Attempting to offer quest: ", quest_id)
	
	for quest in quests:
		if quest.quest_id == quest_id and quest.state == "not_started":
			quest.state = "in_progress"
			for objective in quest.objectives:
				if objective.target_type == "collection":
					var amount_found = 0
					for slot in Global.inventory.slots:
						if slot.item != null and slot.item.id == objective.target_id: #kas vaja != null
							amount_found += slot.amount #miks mitte =
					var how_much_more = abs(objective.collected_quantity - objective.required_quantity)
					if amount_found >= how_much_more:
						quest.complete_objective(objective.id, amount_found)
						Global.inventory.use_item(int(objective.target_id), objective.required_quantity)
						print("All done with quest ", objective.target_id)
						#call rewards/completion
						if quest.is_completed():
							Global.player.call("handle_quest_completion", quest)
					elif amount_found < how_much_more:
						quest.complete_objective(objective.id, amount_found)
						Global.inventory.use_item(int(objective.target_id), objective.required_quantity)
						print("Progress added for objective:", objective.target_id)
			quest_manager.add_quest(quest)
			return
	
	print("Quest not found or started already")

# Returns quest dialog
func get_quest_dialog() -> Dictionary:
	var active_quests = quest_manager.get_active_quests()
	for quest in active_quests:
		for objective in quest.objectives:
			if objective.target_id == npc_id and objective.target_type == "talk_to" and not objective.is_completed:
				if current_state == "start":
					return {"text": objective.objective_dialog, "options": {}}
			
	return {"text": "", "options": {}}
