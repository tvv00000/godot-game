extends Control

@onready var inv: Inventory = preload("res://Scenes/Inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var item_info = $ItemInfo
@onready var info_label = $ItemInfo/VBoxContainer/NameLabel
@onready var info_label2 = $ItemInfo/VBoxContainer/DescriptionLabel
@onready var pickup_label = $PickupLabel
@onready var camera = $"../Player/Pivot_Camera/Camera3D"

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].ui_ref = self
		slots[i].update(inv.slots[i], i, inv)

func _process(delta):
	if Input.is_action_just_pressed("OpenInv"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

#avab inventaris itemi peale vajutades väikse popup akna selle itemi infoga
func item_info_popup(slot: InvSlot, position: Vector2):
	if slot.item:
		info_label.text = slot.item.name
		info_label2.text = slot.item.description
		item_info.popup(Rect2(position, Vector2(150, 50)))


func pickup_message(position_3d: Vector3, message: String):
	var viewport := get_viewport()
	var screen_pos = camera.unproject_position(position_3d)
	pickup_label.text = message
	pickup_label.global_position = screen_pos + Vector2(0, -30)
	pickup_label.visible = true	
	pickup_label.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(pickup_label, "modulate:a", 0.0, 1.5)
	tween.tween_callback(Callable(pickup_label, "hide"))
