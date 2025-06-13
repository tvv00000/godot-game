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
	Global.inventory = inv


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].ui_ref = self
		slots[i].update(inv.slots[i], i, inv)

##Commenti tagasi sisse, et testlevelis inventory kasutada
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
	if is_open:
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
		show_popup_message("Ese kasutatud!")

#popup, mis ilmub eseme kasutamisel
func show_popup_message(message: String) -> void:
	pickup_label.text = message
	pickup_label.global_position = Vector2(630, 220)
	pickup_label.visible = true
	pickup_label.modulate.a = 1.0
	
	var tween := create_tween()
	tween.tween_property(pickup_label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(Callable(pickup_label, "hide"))

func get_selected_item() -> InvItem:
	if current_slot >= 0 and current_slot < inv.slots.size():
		return inv.slots[current_slot].item
	return null
