extends Node3D

@onready var animationPlayer: AnimationPlayer = $SunPivot/DirectionalLight3D/AnimationPlayer
@export var currentTime: float = 12.0
@export var enableCycle: bool = true
@export var realTime: bool = true
@export var timeMultiplyer: int = 1
var timeScale = 0.0036


func setTime():
	
	if enableCycle:
		
		if realTime:
			currentTime = int(Time.get_time_string_from_system(false).left(2))
			animationPlayer.seek(float(currentTime), true)
			animationPlayer.play("dayNightCycle",-1, timeScale)
			
		if realTime == false:
			timeScale = timeMultiplyer * 0.0036
			animationPlayer.play("dayNightCycle",-1, timeScale)
			animationPlayer.seek(currentTime, true)
			
	else:
		animationPlayer.seek(currentTime, true)
		animationPlayer.pause()
		
	print("Welcome, developer! Current time is: ", currentTime, " Day/night cycle activation is: ", enableCycle, " and timescale is: ", timeScale)
	print("Current animation time is: ", animationPlayer.current_animation_position)
	print(" animatsioon liigub ajaskaalal ", timeScale)
	


func _ready() -> void:


	setTime()
