extends Area2D

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.EquipSkin.connect(setskin)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#position.x = $Kontrola.value
	pass

func setskin(val):
	print("DZIAŁA val=", val)
	match val:
		1:
			print("WYBRANO ID 1")
			$Sprite2D.texture = preload("res://Skins/Classic/Soccer_ball.svg")
			print("TESKTURA LOADED")
			$Sprite2D.scale.x = 0.025
			$Sprite2D.scale.y = 0.025
			print("X:", $Sprite2D.scale.x)
			print("Y:", $Sprite2D.scale.y)
			GlobalVariables.ChangeEquipped(val)
		2:
			print("WYBRANO ID 2")
			$Sprite2D.texture = preload("res://Skins/Golden/statekmidas.png")
			print("TESKTURA LOADED")
			$Sprite2D.scale.x = 0.034
			$Sprite2D.scale.y = 0.034
			print("X:", $Sprite2D.scale.x)
			print("Y:", $Sprite2D.scale.y)
			GlobalVariables.ChangeEquipped(val)
		3:
			print("WYBRANO ID 3")
			$Sprite2D.texture = preload("res://Skins/kosmita.png")
			print("TESKTURA LOADED")
			$Sprite2D.scale.x = 0.116
			$Sprite2D.scale.y = 0.116
			print("X:", $Sprite2D.scale.x)
			print("Y:", $Sprite2D.scale.y)
			GlobalVariables.ChangeEquipped(val)
		_:
			print("Wczytywanie Domyślnego Skina")
			$Sprite2D.scale.x = 0.034
			$Sprite2D.scale.y = 0.034
			$Sprite2D.texture = load("res://statek.png")
			GlobalVariables.ChangeEquipped(val)

func uderzono(_area):
	emit_signal("hit")
