extends Control

var is_open = false

func open():
	visible = true
	is_open = true
	print("Window should be visible")

func close():
	visible = false
	is_open = false
