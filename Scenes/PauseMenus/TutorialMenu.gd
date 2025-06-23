extends Control

@onready var tutorialText = $TextureRect/VBoxContainer/TutorialText

func _ready():
	show()

func show_tutorial(msg: String):
	tutorialText.text = msg
	Global.isInteracting = true
	await get_tree().create_timer(0.1).timeout
	show()
	


func _on_tutorial_exit_btn_pressed() -> void:
	closeMenu()

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_released("Move_Jump") or Input.is_action_pressed("UI_Interact"):
		closeMenu()
		
func closeMenu():
	Global.isInteracting = false
	hide()
