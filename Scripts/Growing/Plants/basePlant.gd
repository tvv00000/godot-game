extends Resource
class_name Plants

#ditto
@export var name: String = "taimenimi"
#kui hästi ta väärkohtlemist üle elab.
@export var toughness: int = 1
#palju ta vett vajab mõelda kuidas paremini teha.
@export var waterNeed: float = 100.0
#kasvukiirus
@export var growSpeed: int = 1
#mitu protsenti mulda vaja, ylejäänd on kruus.
@export var dirtNeed: int = 80
#päikselisuse vajadus. 0 - tahab varju, 5- tahab osalist päikest, 10 tahab täispäikest.
@export var sunNeed: int = 5
#v'etis. idk mingi array värk ehk?
@export var fertNeed: int = 3
