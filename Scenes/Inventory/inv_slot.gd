extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label

var slotNr = null
var inventory_ref = null

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

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if inventory_ref and slotNr >= 0:
			if get_global_rect().has_point(get_global_mouse_position()):
				inventory_ref.use_item(slotNr)
