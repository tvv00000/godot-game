extends Resource

class_name Inventory

signal update

@export var slots: Array[InvSlot]

func _ready():
	Global.inventory = self

func insert(item: InvItem, item_quantity):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += item_quantity
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = item_quantity
	update.emit()

#Kasutab itemi ning eemaldab selle inventarist
func use_item(slotNr: int, amount: int):
	if slotNr < 0 or slotNr >= slots.size():
		return
	var slot = slots[slotNr]
	if slot.item:
		slot.item.use()
		slot.amount -= 1 * amount
		if slot.amount <= 0:
			slot.item = null
			slot.amount = 0
		update.emit()
