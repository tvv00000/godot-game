extends Control
@onready var inventory_menu = $"../PauseMenu"
@onready var settingsSettings = $"../SettingsSettings"
@onready var hoverSfx = $HoverSfx
@onready var clickSfx = $ClickSfx

func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	clickSfx.play()
	hide()
	inventory_menu.show()

func _on_heli_pressed() -> void:
	clickSfx.play()
	settingsSettings.show()


func _on_quit_pressed() -> void:
	clickSfx.play()
	get_tree().quit()


func _on_resume_mouse_entered() -> void:
	hoverSfx.play()


func _on_settings_mouse_entered() -> void:
	hoverSfx.play()


func _on_quit_mouse_entered() -> void:
	hoverSfx.play()
