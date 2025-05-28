extends StaticBody3D

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactName: String
#kasvatus
@export var Plant: Resource = null
var plantGrowth: int = 0
var growAmount: int = 0
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
	
	print("growplant func käivitatus, kasvatab {taim}".format({"taim": Plant.name}))
	if planterState == 2:
		print("growing plant")
		growAmount = 0
		if moisture > Plant.waterNeed + Plant.toughness:
			growAmount += 5
		if fertilizer > Plant.fertNeed + Plant.toughness:
			growAmount += 5
		if dirtRatio > Plant.dirtNeed - 10 and dirtRatio < Plant.dirtNeed + 10:
			growAmount += 5
			if dirtRatio == Plant.dirtNeed:
				growAmount += 5
				
		plantGrowth += growAmount
		print("plant grew {amount}".format({"amount": growAmount}))
		
		if plantGrowth > 100:
			print("Plant fully grown!")
		 
func _ready():
	planterStater(planterState)
	
func onInteract():
	if Plant:
		print("Siin kasvab: ", Plant.name, " Planterstate on: ", planterState)
	else: 
		print("Planterstate on: ", planterState)
	
	
	
