extends RigidBody2D

var speed = 400
var homing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	match  GlobalVariables.EquippedSkin:
		1:
			$Sprite2D.texture = preload("res://Skins/Classic/Soccer_ball.svg")
			$Sprite2D.scale.x = 0.051
			$Sprite2D.scale.y = 0.051
		_:
			$Sprite2D.texture = preload("res://kula.png")
			$Sprite2D.scale.x = 0.02
			$Sprite2D.scale.y = 0.02
	if GlobalVariables.HomingLevel > 0:
		if randi() % (101 - GlobalVariables.HomingLevel) == 0:
			homing = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func poza_ekranem():
	queue_free()
 


func trafiony(_area):
	if homing:
		pass
	else:
		queue_free()
