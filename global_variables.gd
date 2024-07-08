extends Node

var cash = 0
var SpeedLevel = 0
var MoneyLevel = 0
var HomingLevel = 0
var ShieldLevel = 0
var EquippedSkin = 0
var WhereAmI = 0 # 0 - main menu, 1 - ingame, 2 pause, 3 - shop, 4 - credits
var OwnedSkins = [true, false, false, false, false]
signal save
signal EquipSkin
signal insufficient_funds

func Update_Cash(amount):
	GlobalVariables.cash += amount
	print("Masz teraz: ", GlobalVariables.cash, " pieniędzy")
func Buy_Skin(ID):
	OwnedSkins[ID] = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func ChangeEquipped(id):
	EquippedSkin = id
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func za_malo_kasy():
	print("TOAST DETECTED")
