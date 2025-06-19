extends Control

@onready var inventory_menu = $"../PauseMenu"
@onready var Settings = $"../SettingsMenu"
@onready var hoverSfx = $HoverSfx
@onready var clickSfx = $ClickSfx

func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	clickSfx.play()
	hide()
	inventory_menu.resume()
	

func _on_inventory_pressed() -> void:
	clickSfx.play()
	hide()
	inventory_menu.show()


func _on_options_menu_pressed() -> void:
	clickSfx.play()
	hide()
	Settings.show()


func _on_resume_mouse_entered() -> void:
	hoverSfx.play()


func _on_inventory_mouse_entered() -> void:
	hoverSfx.play()


func _on_options_menu_mouse_entered() -> void:
	hoverSfx.play()
