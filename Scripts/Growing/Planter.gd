extends StaticBody3D

#TODO: tee taime elu ja suremine korda vms

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactLabel: String = ""
#kasvatus
@export var Plant: Resource = null
var plantGrowth: int = 0
#growAmount on palju taim 1 sükliga kasvab. 
var growAmount: int = 0
var plantHealth: int = 0
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

#see funk haldab taimede kasvu, pane readysse ja oninteracti et ta uuendaks mõistlikult
func growPlant():
	if Plant:
		print("planterstate: ", planterState, Plant.name)
		
		if planterState == 2 and plantGrowth < 100 and plantHealth > 0:
			growAmount = 0
			print("grow step 1")
		if moisture > Plant.waterNeed - Plant.toughness:
			growAmount += 5
			print("moisture attained, step 2")
		if fertilizer > Plant.fertNeed - Plant.toughness:
			growAmount += 5
			print("fert attained, step3")
		if dirtRatio > Plant.dirtNeed - 10 and dirtRatio < Plant.dirtNeed + 10:
			growAmount += 5
			print("dirtratio fine, ste4")
			if dirtRatio == Plant.dirtNeed:
				growAmount += 5
				print("dirtratio perfec, step5")
				
		plantGrowth += growAmount
		
		if growAmount > 10 - Plant.toughness and plantHealth < 100:
			plantHealth += 10
			if plantHealth > Plant.health:
				plantHealth = Plant.health
				
		if plantGrowth > 100:
			plantGrowth = 100
			print("Plant fully grown!")
			
		damagePlant()
		consumeResources("all")
		updatePlantSprite()

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

func damagePlant():
	var plantDamage: int = 0
	if moisture < Plant.waterNeed:
		plantDamage += 10
	if fertilizer < Plant.fertNeed:
		plantDamage += 10
	
	plantHealth -= plantDamage

func uprootPlant():
	Plant = null
	moisture = 0
	fertilizer = 0
	planterStater(0)
	print("taim uprootitud (juurest üles)")

func waterPlant():
	moisture = 100

#TODO: pane see funkama.
func updateDirt(moistness):
	var material = $DirtMesh.get_active_material(0)
	var dirtDry: Color = Color(0.25, 0.21, 0.12) 
	var dirtWet: Color = Color(0.11, 0.06, 0.02)
	material.albedo_color = dirtDry + (dirtWet - dirtDry) * (moistness / 100) 

#TODO: see ka naq
func updatePlantSprite():
	var Sprite = $PlantSprite
	if !planterState == 2:
		Sprite.texture = null
		Sprite.hide()
	else:
		Sprite.show()
		if plantHealth < 30:
			Sprite.frame = 4
		elif plantGrowth < 30:
			Sprite.frame + 0
		elif plantGrowth > 30 and plantGrowth < 60:
			Sprite.frame = 1
		elif plantGrowth > 60:
			Sprite.frame = 2
		elif plantGrowth == 100:
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
