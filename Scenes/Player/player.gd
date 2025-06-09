extends CharacterBody3D

#Muutujate init. 
#Protip: Nõnda initsialiseerides tuleb performans märgatavalt parem. (juttude järgi)
const SPEED: float = 5.0
const JUMP_VELOCITY:float = 4.5
var can_move:bool = true

@export var inventory: Inventory
var ui_ref: Control

@onready var sfx_jump = $sfx_jump

@onready var ray_cast_3d = $RayCast3D
@onready var amount = $HUD/Coins/Amount
@onready var quest_tracker = $HUD/QuestTracker
@onready var title = $HUD/QuestTracker/Details/Title
@onready var objectives = $HUD/QuestTracker/Details/Objectives
#Interaktsioon siit allpool.
@onready var prompt = $Prompt
@onready var InteractionArea = $InteractionArea

func _ready() -> void:
	Global.player = self
	quest_tracker.visible = false

func _physics_process(delta: float) -> void:
	if can_move:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("Move_Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			sfx_jump.play()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		# raycast direction
		if velocity != Vector3.ZERO:
			ray_cast_3d.target_position = velocity.normalized() * 3
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func _input(event):
	#Interact with NPC/ Quest Item
	if can_move:
		if event.is_action_pressed("UI_Interact"):
			var target = ray_cast_3d.get_collider()
			if target != null:
				
				if target.is_in_group("NPC"):
					print("I'm talking to an NPC!")
					can_move = false
					target.start_dialog()
					
				elif target.is_in_group("Item"):
					print("I'm interacting with an item!")
					# todo: check if item is needed for quest
					# todo: remove item
					target.start_interact()
					
				elif target.is_in_group("Planter"):
					print("ceci n'est pas une planteur")


func collect(item):
	inventory.insert(item)

func _on_signal_movement_enabled() -> void:
	can_move = true


func _on_movement_disabled() -> void:
	can_move = false
