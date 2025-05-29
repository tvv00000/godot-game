extends StaticBody3D

#TODO: tee taime elu ja suremine korda vms

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactName: String
#kasvatus
@export var Plant: Resource = null
var plantGrowth: int = 0
var growAmount: int = 0
var plantHealth: int = 0
#0 - tühi, 1 - mullaga, 2 - taimega
@export var planterState: int
@export var dirtRatio: int
@export var moisture: int
@export var fertilizer: int



func planterStater(setState):
	#Kui planter on tühi
	if planterState == 0:
		$DirtMesh.hide()
		Plant = null
		interactName = "Täida mullaga"
		
	#Kui muld on lisatud
	elif planterState == 1:
		$DirtMesh.show()
		Plant = null
		interactName = "Istuta Taim"
		
	#Kui taim kasvab.
	elif Plant == null and planterState == 2:
		print("error, siin peaks olema taim. Planterstate muudetud 1ks!")
		planterState = 1
		
	elif Plant and  planterState == 2:
		interactName = "Siin Kasvab " + Plant.name
		
#see funk haldab taimede kasvu, pane readysse ja oninteracti et ta uuendaks mõistlikult
func growPlant():
	
	if planterState == 2 and Plant and plantGrowth < 100 and plantHealth > 0:
		growAmount = 0
		if moisture > Plant.waterNeed - Plant.toughness:
			growAmount += 5
		if fertilizer > Plant.fertNeed - Plant.toughness:
			growAmount += 5
		if dirtRatio > Plant.dirtNeed - 10 and dirtRatio < Plant.dirtNeed + 10:
			growAmount += 5
			if dirtRatio == Plant.dirtNeed:
				growAmount += 5
				
		plantGrowth += growAmount
		if growAmount > 10 - Plant.toughness and plantHealth < 100:
			plantHealth += 10
			if plantHealth > Plant.health:
				plantHealth = Plant.health
			
			
		print("plant grew {amount}. total Grow: {growTotal}".format({"amount": growAmount, "growTotal": plantGrowth}))
		
	if plantGrowth > 100:
		plantGrowth = 100
		print("Plant fully grown!")
	
	damagePlant()
	consumeResources()

func consumeResources():
	moisture -= 10
	if moisture < 0:
		moisture = 0
	
	fertilizer -= 5
	if fertilizer < 0:
		fertilizer = 0
		 
func damagePlant():
	var plantDamage: int = 0
	if moisture < Plant.waterNeed:
		plantDamage += 10
	if fertilizer < Plant.fertNeed:
		plantDamage += 10
	
	plantHealth -= plantDamage
		
	
func _ready():
	planterStater(planterState)
	
func onInteract():
	if Plant:
		print("Siin kasvab: ", Plant.name, " Planterstate on: ", planterState)
	else: 
		print("Planterstate on: ", planterState)
	
	
	
