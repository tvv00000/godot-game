extends Control
@onready var inventory_menu = $"../PauseMenu"

func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	hide()
	inventory_menu.show()


func _on_graafika_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_heli_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_quit_pressed() -> void:
	get_tree().quit()
