### NPC.gd

extends StaticBody3D

@onready var dialog_manager = $DialogManager
@export var spriteTexture: Resource
@export var npc_id: String
@export var npc_name: String
@export var interactLabel: String = "Alusta Vestlust"
var current_state = "start"
var current_branch_index = 0
var dialogs = {}

func _ready():
	# Load dialog data 
	#Ta teeb seda nüüd oma npc failist
	load_from_json("res://Resources/Dialog/dialog_{0}.json".format([npc_id]))
		# Initialize npc ref
	dialog_manager.npc = self
	$Pivot/Sprite.set_texture(spriteTexture)

func start_dialog():
	print("Laetud dialoog dialog_{0}.json".format([npc_id]))
	var npc_dialogs = get_npc_dialog(npc_id)
	if npc_dialogs.is_empty():
		print("No npc dialogs finded.")
		return
	dialog_manager.show_dialog(self)

# Get current branch dialog
func  get_current_dialog():
	var npc_dialogs = get_npc_dialog(npc_id) 
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
	
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogs = parsed_data
	else:
		print("Failed to parse: ", npc_id)

# Return individual NPC dialogs
func get_npc_dialog(npc_id):
	if npc_id in dialogs:
		return dialogs[npc_id]["trees"]
	else:
		return []
