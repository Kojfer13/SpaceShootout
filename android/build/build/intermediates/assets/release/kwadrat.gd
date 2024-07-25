extends RigidBody2D

signal point
signal poza
signal cash
signal DefPos
var gold = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if(randi() % (10 - GlobalVariables.MoneyLevel) == 1):
		gold = true
	skin(GlobalVariables.EquippedSkin, gold)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func skin(id, ifgolden):
	print("Spawnuje Kosmite ze skinem: ", id)
	match id:
		1:
			if ifgolden:
				$Sprite2D.texture = preload("res://Skins/Classic/GoldenSquare.png")
			else:
				$Sprite2D.texture = preload("res://Skins/Classic/kwadrat.png")
			$Sprite2D.scale.x = 2.453
			$Sprite2D.scale.y = 2.313
			$Sprite2D.rotation = 0
		2:
			if ifgolden:
				$Sprite2D.texture = preload("res://Skins/Golden/diamondalien.png")
			else:
				$Sprite2D.texture = preload("res://Skins/Golden/midasalien.png")
			$Sprite2D.scale.x = 1
			$Sprite2D.scale.y = 1
			$Sprite2D.rotation = 0
		3:
			if ifgolden:
				$Sprite2D.texture = preload("res://Skins/Golden/spaceshipmidas.png")
			else:
				$Sprite2D.texture = preload("res://spaceship.png")
			$Sprite2D.scale.x = 0.3
			$Sprite2D.scale.y = 0.3
			$Sprite2D.rotation = deg_to_rad(180)
		_:
			print("DEF KOSMICI")
			if ifgolden:
				$Sprite2D.texture = preload("res://Skins/Golden/midasalien.png")
			else:
				$Sprite2D.texture = preload("res://Skins/alien.png")
			$Sprite2D.scale.x = 1
			$Sprite2D.scale.y = 1
			$Sprite2D.rotation = 0
func _process(_delta):
	pass


func trafiony(_body):
	point.emit()
	if gold:
		cash.emit(100)
		print("Cash Emited")
		DefPos.emit(position)
		print("Particle emitted")
		#var sto = preload("res://cashparticle.tscn").instantiate()
		#sto.position = position
		#add_child(sto)
		pass
	queue_free()
func setskin(val):
	match val:
		1:
			$Sprite2D.set_texture = preload("res://Skins/Classic/kwadrat.png")
		_:
			$Sprite2D.set_texture = preload("res://Skins/alien.png")
func poza_ekranem():
	poza.emit()
	queue_free()
