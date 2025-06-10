extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label

var slotNr = null
var inventory_ref = null
var ui_ref: Control = null

func update(slot: InvSlot, index: int, inventory: Inventory):
	slotNr = index
	inventory_ref = inventory
	
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		amount_text.visible = true
		amount_text.text = str(slot.amount)

signal slot_input(slot_index: int, action: int)

#Kasutab vasaklõpsul itemit
func _input(event):
	if event is InputEventMouseButton:
		if inventory_ref and slotNr >= 0:
			if get_global_rect().has_point(get_global_mouse_position()):
				#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					#inventory_ref.use_item(slotNr)
				if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
					ui_ref.item_info_popup(inventory_ref.slots[slotNr], get_global_mouse_position())
					
