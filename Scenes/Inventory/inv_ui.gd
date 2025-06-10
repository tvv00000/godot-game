extends Control

@onready var inv: Inventory = preload("res://Scenes/Inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var item_info = $ItemInfo
@onready var info_label = $ItemInfo/VBoxContainer/NameLabel
@onready var info_label2 = $ItemInfo/VBoxContainer/DescriptionLabel
@onready var pickup_label = $PickupLabel
@onready var camera = $"../Player/Pivot_Camera/Camera3D"
@onready var use_button = $ItemInfo/VBoxContainer/UseButton

var is_open = false
var current_slot: int = -1

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	Global.inv_ui = self


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
		current_slot = inv.slots.find(slot)
		use_button.show()
		item_info.popup(Rect2(position, Vector2(150, 80)))

#Itemi kasutamise nupp
func _on_use_button_pressed() -> void:
	if current_slot >= 0:
		inv.use_item(current_slot)
		item_info.hide()
		current_slot= -1
		use_button.hide()
