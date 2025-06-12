extends CharacterBody3D

#Muutujate init. 
#Protip: Nõnda initsialiseerides tuleb performans märgatavalt parem. (juttude järgi)
const SPEED: float = 5.0
const JUMP_VELOCITY:float = 4.5
var can_move:bool = true
const SPRINT_MULTIPLIER: float = 10.0

@export var inventory: Inventory
var ui_ref: Control


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
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()


func collect(item):
	inventory.insert(item)

func _on_signal_movement_enabled() -> void:
	print("movementenabled")
	can_move = true

func _on_movement_disabled() -> void:
	print("movementdisabled")
	can_move = false

#allpool raha süsteem
var current_money: int = 0

signal money_collected(amount_added:int, new_total:int)

func add_money(amount:int) -> void:
	current_money += amount
	print("Player now has %d money" % current_money)
	money_collected.emit(amount, current_money)


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
