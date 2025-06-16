extends StaticBody3D

#TODO: tee taime elu ja suremine korda vms

#võtab asju interactable area3d nodelt.
@onready var timer: Timer = $Timer

@export var interactLabel: String = ""
#kasvatus
@export var Plant1: Resource = null
@export var Plant2: Resource = null
var plantList: Array = []
var plantGrowList: Dictionary = {"Plant1":{"state": 0,"growth": 0, "health": 0},
							"Plant2":{"state": 0,"growth": 0, "health": 0}}
#growAmount on palju taim 1 sükliga kasvab. 
var growAmount: int = 0
#0 - tühi, 1 - mullaga, 2 - taimega
@export var planterState: int
@export var dirtRatio: int
@export var moisture: int
@export var fertilizer: int

func planterStater(setState):
	#Kui planter on tühi
	planterState = setState
	if planterState == 0:
		$DirtMesh.hide()
		Plant1 = null
		Plant2 = null
		interactLabel = "Täida mullaga"
		
	#Kui muld on lisatud
	elif planterState == 1:
		$DirtMesh.show()
		Plant1 = null
		Plant2 = null
		interactLabel = "Istuta Taimi"
		
	#Kui taim kasvab.
	elif Plant1 or Plant2 == null and planterState == 2:
		print("error, siin peaks olema taim. Planterstate muudetud 1ks!")
		planterState = 1
		
	elif Plant1 or Plant2 and  planterState == 2:
		if Plant1 && !Plant2:
			interactLabel = str("Siin Kasvab {0}".format([Plant1.name]))
		if !Plant1 && Plant2:
			interactLabel = str("Siin Kasvab {0}".format([Plant2.name]))
		else:
			interactLabel = str("Siin Kasvab {0} ja {1}".format([Plant1.name, Plant2.name]))

#see pistab 
func setPlant(plant):
	if plantList.size() < 2:
		plantList.append(plant)

#see funk haldab taimede kasvu, pane readysse ja oninteracti et ta uuendaks mõistlikult
func growPlant():
	if plantList:
		for growingPlant in plantList:
			if growingPlant:
				print("planterstate: ", planterState, growingPlant.name)
				
				if plantGrowList[growingPlant["growth"]] < 100 and plantGrowList[growingPlant["health"]] > 0:
					growAmount = 0
					print("grow step 1")
				if moisture > growingPlant.waterNeed - growingPlant.toughness:
					growAmount += 5
					print("moisture attained, step 2")
				if fertilizer > growingPlant.fertNeed - growingPlant.toughness:
					growAmount += 5
					print("fert attained, step3")
				if dirtRatio > growingPlant.dirtNeed - 10 and dirtRatio < growingPlant.dirtNeed + 10:
					growAmount += 5
					print("dirtratio fine, ste4")
					if dirtRatio == growingPlant.dirtNeed:
						growAmount += 5
						print("dirtratio perfec, step5")
						
				plantGrowList[growingPlant["growth"]] += growAmount
				
				if growAmount > 10 - growingPlant.toughness and plantGrowList[growingPlant["health"]] < 100:
					plantGrowList[growingPlant["health"]] += 10
					if plantGrowList[growingPlant["health"]] > growingPlant.health:
						plantGrowList[growingPlant["health"]] = growingPlant.health
						
				if plantGrowList[growingPlant["growth"]] > 100:
					plantGrowList[growingPlant["growth"]] = 100
					print("Plant fully grown!")
					
				damagePlant(growingPlant)
				consumeResources("all")

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

func damagePlant(hurtablePlant):
	var plantDamage: int = 0
	if moisture < hurtablePlant.waterNeed:
		plantDamage += 10
	if fertilizer < hurtablePlant.fertNeed:
		plantDamage += 10
	
	plantGrowList[hurtablePlant["health"]] -= plantDamage

func uprootPlant():
	Plant1 = null
	Plant2 = null
	moisture = 0
	fertilizer = 0
	planterStater(0)
	interactLabel = "Taimed välja juuritud!"
	#print("taim uprootitud (juurest üles)")
	timer.start()

func waterPlant():
	moisture = 100

#TODO: pane see funkama.
func updateDirt(moistness):
	var material = $DirtMesh.get_active_material(0)
	var dirtDry: Color = Color(0.25, 0.21, 0.12) 
	var dirtWet: Color = Color(0.11, 0.06, 0.02)
	material.albedo_color = dirtDry + (dirtWet - dirtDry) * (moistness / 100) 

func _ready():
	planterStater(planterState)
	updateDirt(moisture)

func onInteract():
	for plant in plantList :
		print("Siin kasvab: ", plant.name)
	print(" Planterstate on: ", planterState)


func _on_timer_timeout() -> void:
	interactLabel = "Täida mullaga!"

	
