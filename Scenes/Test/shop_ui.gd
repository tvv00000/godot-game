extends Control

var can_move:bool = true

signal shop_ui_open
signal shop_ui_closed

func open():
	show()
	can_move = false
	emit_signal("shop_ui_open")

func close():
	hide()
	can_move = true
	emit_signal("shop_ui_closed")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		close()


func _ready() -> void:
	hide()
