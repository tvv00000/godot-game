extends StaticBody3D

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactName: String = ""
#kasvatus
@export var plantPath: String
@export var Plant: Resource = null
#0 - tühi, 1 - mullaga, 2 - taimega
@export var planterState: int = 0
@export var dirtRatio: int = 50

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
		


func _ready():
	planterStater(planterState)

func onInteract():
	print("Siin kasvab: ", Plant, "Planterstate on: ", planterState)
	
	
