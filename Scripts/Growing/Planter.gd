extends StaticBody3D

#TODO: tee taime elu ja suremine korda vms

#võtab asju interactable area3d nodelt.
@onready var timer: Timer = $Timer

@export var interactLabel: String = ""
#kasvatus
@export var Plant: Resource = null
var plantGrowth: int = 0
#growAmount on palju taim 1 sükliga kasvab. 
var growAmount: int = 0
#elud algavad 50nst et simuleerida noore taime nõrkust
var plantHealth: int = 50
#0 - tühi, 1 - mullaga, 2 - taimega
@export var planterState: int
@export var dirtRatio: int
@export var moisture: int
@export var fertilizer: int
@export var planter_id: String

func planterStater(setState):
	#Kui planter on tühi
	planterState = setState
	if planterState == 0:
		$DirtMesh.hide()
		Plant = null
		interactLabel = "Täida mullaga"
		
	#Kui muld on lisatud
	elif planterState == 1:
		$DirtMesh.show()
		Plant = null
		interactLabel = "Istuta Taim"
		
	#Kui taim kasvab.
	elif Plant == null and planterState == 2:
		print("error, siin peaks olema taim. Planterstate muudetud 1ks!")
		planterState = 1
		
	elif Plant and  planterState == 2:
		interactLabel = str("Siin Kasvab " + Plant.name)
	
	#valmis taim
	elif planterState == 3:
		interactLabel = str("Korja ", Plant.name,"i seemneid")

#see funk haldab taimede kasvu, pane readysse ja oninteracti et ta uuendaks mõistlikult
func growPlant():
	
	if Plant:
		print("planterstate: ", planterState, Plant.name)
		
		#kasvava taime elu
		if plantHealth > 0:
			if plantGrowth < 100:
				if moisture > Plant.waterNeed:
					if planterState == 2 and plantGrowth < 100:
						growAmount = 0
						print("grow step 1")
					if moisture > Plant.waterNeed - Plant.toughness:
						growAmount += 5
						plantHealth += 5
						print("moisture attained, step 2")
					if fertilizer > Plant.fertNeed - Plant.toughness:
						growAmount += 5
						plantHealth += 5
						print("fert attained, step3")
					if dirtRatio > Plant.dirtNeed - 10 and dirtRatio < Plant.dirtNeed + 10:
						growAmount += 5
						print("dirtratio fine, ste4")
						if dirtRatio == Plant.dirtNeed:
							growAmount += 5
							print("dirtratio perfec, step5")
							
					plantGrowth += growAmount
					
					#taime elu clamp
					if plantHealth > Plant.health:
						plantHealth = Plant.health
						
					#kasvava taime lõputsekid
					damagePlant()
					consumeResources("all")
					updatePlantSprite()
				#kui ainult seeme on kuivas mullas siis nagu midagi ei toimu
				if plantGrowth == 0 and moisture == 0:
					pass
					
			#valmis taim.
			if plantGrowth > 100:
				planterStater(3)
				plantGrowth = 100
				print("Plant fully grown!")
					
				damagePlant()
				consumeResources("all")
				updatePlantSprite()
				
		if plantHealth < 0:
			plantHealth = 0
		print("Planthealth on:", plantHealth)

	else:
		consumeResources("empty")

func consumeResources(state: String):
	moisture -= 10
	if moisture < 0:
		moisture = 0
			
	match state:
		"all":
			fertilizer -= 5
			if fertilizer < 0:
				fertilizer = 0
		"empty":
			pass
	updateDirt(moisture)

#dammib planti kui sellel pole vett.
func damagePlant():
	if moisture < Plant.waterNeed:
		plantHealth -= 10

func uprootPlant():
	Plant = null
	moisture = 0
	fertilizer = 0
	planterStater(0)
	interactLabel = "Taim välja juuritud!"
	print("taim uprootitud (juurest üles)")
	timer.start()

func waterPlant():
	moisture = 100

#TODO: pane see funkama.
func updateDirt(moistness):
	var material = $DirtMesh.get_active_material(0)
	var dirtDry: Color = Color(1, 1, 1) 
	var dirtWet: Color = Color(0.11, 0.06, 0.02)
	var wetness: float = moistness / 100
	material.albedo_color = lerp(dirtWet, dirtDry, wetness)

func updatePlantSprite():
	var Sprite = $PlantSprite
	if planterState < 2:
		Sprite.texture = null
		Sprite.hide()
	else:
		Sprite.texture = Plant.sprite
		Sprite.show()
		
		if plantHealth < 30:
			Sprite.frame = 4
		else: 
			match plantGrowth:
				0:
					Sprite.frame = 0
				30:
					Sprite.frame = 1
				60:
					Sprite.frame = 2
				100:
					Sprite.frame = 3

func _ready():
	planterStater(planterState)
	updateDirt(moisture)
	updatePlantSprite()

func onInteract():
	if Plant:
		print("Siin kasvab: ", Plant.name, " Planterstate on: ", planterState)
	else: 
		print("Planterstate on: ", planterState)

func _on_timer_timeout() -> void:
	interactLabel = "Täida mullaga!"

func get_save_data() -> Dictionary:
	return {
		"planter_id": planter_id,
		"plant": Plant.resource_path if Plant else "",
		"plantGrowth": plantGrowth,
		"plantHealth": plantHealth,
		"planterState": planterState,
		"dirtRatio": dirtRatio,
		"moisture": moisture,
		"fertilizer": fertilizer
	}

func load_data(data: Dictionary):
	if data["plant"] != "":
		Plant = load(data["plant"])
	else:
		Plant = null
	print("Loading planter: ", planter_id, " with data: ", data)
	plantGrowth = data["plantGrowth"]
	plantHealth = data["plantHealth"]
	planterState = data["planterState"]
	dirtRatio = data["dirtRatio"]
	moisture = data["moisture"]
	fertilizer = data["fertilizer"]

	planterStater(planterState)
	updateDirt(moisture)
	updatePlantSprite()
