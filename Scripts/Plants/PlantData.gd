extends Resource
class_name PlantData

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var is_discovered: bool = false
@export var is_collected: bool = false

#add more
@export var growingTime:int

#kui hästi ta väärkohtlemist üle elab. hea väärtus on 30 supertugev taim, 5 habras taim
@export var toughness: int = 10
#elud
@export var health: int = 100
#palju ta vett vajab. Alla selle niiskusenumbri plus 1/2 toughnessi ta vett ei saa, mida madalam seda tugevam
@export var waterNeed: int = 40
#kasvukiirus
@export var growSpeed: int = 1
#mitu protsenti mulda vaja, ylejäänd on kruus.
@export var dirtNeed: int = 80
#päikselisuse vajadus. Ei ole hetkel kasutuses.
@export var sunNeed: int = 0
#v'etis. idk mingi array värk ehk?
@export var fertNeed: int = 20
#ditto
@export var sprite: Resource
