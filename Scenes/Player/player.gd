extends CharacterBody3D

#Muutujate init. 
#Protip: Nõnda initsialiseerides tuleb performans märgatavalt parem. (juttude järgi)
const SPEED: float = 5.0
const JUMP_VELOCITY:float = 4.5
var can_move:bool = true
const SPRINT_MULTIPLIER: float = 2.0

@export var inventory: Inventory
var ui_ref: Control

@onready var animation: AnimatedSprite3D = $Pivot/AnimatedSprite3D
@onready var sfx_jump = $sfx_jump 
@onready var sfx_death = $sfx_death

#popup item pickupil
var popup: CanvasLayer
@onready var camera = $Pivot_Camera/Camera3D
@onready var amount = $HUD/Coins/Amount
@onready var quest_tracker = $HUD/QuestTracker
@onready var title = $HUD/QuestTracker/Details/Title
@onready var objectives = $HUD/QuestTracker/Details/Objectives
#Interaktsioon siit allpool.
@onready var prompt = $Prompt
@onready var InteractionArea = $InteractionArea
@onready var MapMenu = $HUD/WorldMapUi


@onready var quest_manager = $QuestManager
var selected_quest: Quest = null

func _ready() -> void:
	Global.player = self
	quest_tracker.visible = false
	ui_ref = Global.inv_ui
	Global.camera = camera
	popup = $HUD/Popup
	popup.camera = camera
	var map_menu = $HUD/WorldMapUi
	MapMenu.map_open.connect(_on_world_map_ui_map_open)
	MapMenu.map_closed.connect(_on_world_map_ui_map_closed)
	
	animation.play("Idle")
	print("Scene name:", get_tree().current_scene.name)
	if get_tree().current_scene.name == "root":
			GardenBgMusic.play()
			EuropeBgMusic.stop()
		
	elif get_tree().current_scene.name == "Level_Europe":
		GardenBgMusic.stop()
		EuropeBgMusic.play()
	
	#signals
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objective_updated)
	
	if MapMenu == null:
		print("MAPmenu poLE LEITUD APPPII!!!")
	else:
		print("Alls good in the world :3")

func _physics_process(delta: float) -> void:
	if can_move:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("Move_Jump") and is_on_floor():
			animation.play("Jump")
			velocity.y = JUMP_VELOCITY
			sfx_jump.play()
			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		var is_sprinting := Input.is_action_pressed("Move_Sprint")
		var final_speed := SPEED * SPRINT_MULTIPLIER if is_sprinting else SPEED


		if direction:
			velocity.x = direction.x * final_speed
			velocity.z = direction.z * final_speed
			if is_sprinting:
				animation.play("Run")
				
				if direction.x > 0:
					animation.flip_h = true
				else:
					animation.flip_h = false

				
			else: 
				animation.play("Walk")
				if direction.x > 0:
					animation.flip_h = true
				else:
					animation.flip_h = false

		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
			animation.play("Idle")
		move_and_slide()


func collect(item, inv_item):
	print('korjas ', item)
	if is_item_needed(item, inv_item):
		print("Item is needed for quest")
	else: 
		print("Item not needed for any active quest")

func _on_signal_movement_enabled() -> void:
	print("movementenabled")
	can_move = true

func _on_movement_disabled() -> void:
	print("movementdisabled")
	can_move = false

func _input(event):
	# Open/close quest log
		if event.is_action_pressed("TEMPQUEST"):
			quest_manager.show_hide_log()

# Check if quest item is needed
func is_item_needed(item_id: String, inv_item):
	for uksquest in Global.quest_ui.all_active_quests:
		for objective in uksquest.objectives:
			if objective.target_id == item_id and objective.target_type == "collection" and not objective.is_completed:
				var how_much_more = abs(objective.collected_quantity - objective.required_quantity)
				if how_much_more > 0:
					print("Completing objective for quest: ", objective.id)
					selected_quest = uksquest
					selected_quest.complete_objective(objective.id, 1) #quests.gd
				how_much_more = abs(objective.collected_quantity - objective.required_quantity)
				if how_much_more == 0:
					handle_quest_completion(selected_quest)
				return true
	inventory.insert(inv_item, 1)
	return false

func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1):
	if selected_quest == null:
		return
	# Update objectives
	var objective_updated = false
	for objective in selected_quest.objectives:
		if objective.target_id == target_id and objective.target_type == target_type and not objective.is_completed:
			print("Completing objective for quest: ", selected_quest.quest_name)
			selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	
	# Provide rewards
	if objective_updated:
		if selected_quest.is_completed():
			handle_quest_completion(selected_quest)
	
		# Update UI
		update_quest_tracker(selected_quest)

# Player rewards
func handle_quest_completion(quest: Quest):
	for reward in quest.rewards:
		if reward.reward_type == "coins":
			add_money(reward.reward_amount)
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")

# Update tracker UI
func update_quest_tracker(quest: Quest):
	# if we have an active quest, populate tracker
	if quest:
		quest_tracker.visible = true
		title.text = quest.quest_name	
		
		for child in objectives.get_children():
			objectives.remove_child(child)
			
		for objective in quest.objectives:
			var label = Label.new()
			label.text = objective.description
			
			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1,0, 0))
				
			objectives.add_child(label)
	# no active quest, hide tracker		
	else:
		quest_tracker.visible = false

# Update tracker if quest is complete
func _on_quest_updated(quest_id: String):
	var quest = quest_manager.get_quest(quest_id)
	if quest == selected_quest:
		update_quest_tracker(quest)
	#selected_quest = null ##mdea miks please dont delete

# Update tracker if objective is complete
func _on_objective_updated(quest_id: String, objective_id: String):
	if selected_quest and selected_quest.quest_id == quest_id:
		update_quest_tracker(selected_quest)
	#selected_quest = null ##mdea miks please dont delete
	

var coin_amount  = 0
signal money_collected(amount_added:int, new_total:int)

func add_money(amount:int) -> void:
	coin_amount += amount
	print("Player now has %d money" % coin_amount)
	money_collected.emit(amount, coin_amount)

func check_money() -> int:
	return coin_amount

func _on_world_map_ui_map_closed() -> void:
	print("Map movement enabled")
	can_move = true


func _on_world_map_ui_map_open() -> void:
	can_move = false
	print("Map movement disabled")


func _on_water_kill_body_entered(body: CharacterBody3D) -> void:
		if body.name == "Player":
			
			print("Eksmati uppus ära! Anlaki!")
			get_tree().change_scene_to_file("res://Scenes/GameOver/GameOver.tscn")
			Global.last_loss_reason = "drowned"
