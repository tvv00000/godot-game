extends Control

@onready var plant_index_menu = $"../PlantIndexMenu"
@onready var Settings = $"../SettingsMenu"
@onready var SettingsSettings = $"../SettingsSettings"
@onready var MapMenu = $"../WorldMapUi"
@onready var hoverSfx = $HoverSfx
@onready var clickSfx = $ClickSfx

func resume():
	get_tree().paused = false
	hide()
	Global.inv_ui.close()

func pause():
	if !Global.isInteracting:
		get_tree().paused = true
		show()
		Global.inv_ui.open()

func testTab():
	if Input.is_action_just_pressed('OpenInv') and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed('OpenInv') and get_tree().paused == true:
		resume()
		plant_index_menu.hide()
		Settings.hide()

func _on_resume_pressed() -> void:
	resume()
	clickSfx.play()

func _on_plant_index_pressed() -> void:
	hide()
	plant_index_menu.show()
	clickSfx.play()

func _on_options_menu_pressed() -> void:
	hide()
	Settings.show()
	clickSfx.play()

func _on_mapmenu_btn_pressed() -> void:
	hide()
	pause()
	MapMenu.showMap()
	resume()
	MapMenu.emit_signal("map_open")
	clickSfx.play()

func _process(_delta: float) -> void:
	testTab()

func _ready() -> void:
	hide()
	resume()


func _on_resume_btn_mouse_entered() -> void:
	hoverSfx.play()


func _on_plant_index_btn_mouse_entered() -> void:
	hoverSfx.play()

func _on_options_menu_btn_mouse_entered() -> void:
	hoverSfx.play()

func _on_mapmenu_btn_mouse_entered() -> void:
	hoverSfx.play()
