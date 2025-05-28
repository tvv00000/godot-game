extends Node
#See skript siin kontrollib aja möödumist taimekasvu huvides.

#var gardenTime: String = "1:1" #kasuta .split()i. hooaeg/nädal
#kalendrisüsteem
@export var secondsPerCycle: int = 10
var currentTime: int
var Planters: Array

func updateTime():
	#see võtab eemaloldud aja ja uuendab kuupäeva
	currentTime = Time.get_ticks_msec()
	print("Time to grow!")
	#signal to plant to grow
	Planters = get_children()
	for Planter in Planters:
			Planter.growPlant()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentTime = Time.get_ticks_msec()

	#peaks võtma ja uuendama aia päeva sõltuvalt sellele kas sa oled ära olnud või mängust emal olnud

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - currentTime > secondsPerCycle * 1000:
		updateTime()
