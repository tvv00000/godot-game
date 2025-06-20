extends Node
#See skript siin kontrollib aja möödumist taimekasvu huvides.

#var gardenTime: String = "1:1" #kasuta .split()i. hooaeg/nädal
#kalendrisüsteem
@export var secondsPerCycle: int = 5
var currentTime: int
var Planters: Array
var day: int
var season: int
var  daysElapsed: int

func updateTime():
	
	currentTime = Time.get_ticks_msec()
	#see võtab eemaloldud aja ja uuendab kuupäeva
	if Global.isGardenLevel:
		if Global.totalDays > daysElapsed:
			print("You were gone for {missing} days, growing plants for same amount".format({"missing": Global.totalDays - daysElapsed}))
			while Global.totalDays > daysElapsed:
				growPlants()
				daysElapsed += 1
				
		else: 
			print("Time to grow!")
		#signal to plant to grow
			growPlants()
			daysElapsed += 1

func growPlants():
	Planters = get_children()
	for Planter in Planters:
			Planter.growPlant()

func setDate():
	day += 1
	if day == 6:
		season += 1
		day = 0
		
		if season == 3:
			season = 0
	
	Global.day = day
	Global.season = season

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentTime = Time.get_ticks_msec()
	updateTime()

	#peaks võtma ja uuendama aia päeva sõltuvalt sellele kas sa oled ära olnud või mängust emal olnud

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.isGardenLevel:
		if Time.get_ticks_msec() - currentTime > secondsPerCycle * 1000:
			updateTime()
			setDate()
	else:
		if Time.get_ticks_msec() - currentTime > secondsPerCycle * 2000:
			updateTime()
			setDate()
