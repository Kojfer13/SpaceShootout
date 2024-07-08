extends Control

var id = 0
var price = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func equip():
	GlobalVariables.EquipSkin.emit(id)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
