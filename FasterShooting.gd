extends ItemList

var cost = 200 * (GlobalVariables.SpeedLevel + 1)
var cap = 5
signal save

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.SpeedLevel = 0
	cost = 200 * (GlobalVariables.SpeedLevel + 1)
	$Level.text = "LV %s" % (GlobalVariables.SpeedLevel+1)
	if cap == GlobalVariables.SpeedLevel:
		$Price.text = "Ulepszono Maksymalnie"
	else:
		$Price.text = "%s $" % cost
	print("Koszt:",cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Level.text = "LV %s" % GlobalVariables.SpeedLevel
	if cap == GlobalVariables.SpeedLevel:
		$Price.text = "Ulepszono Maksymalnie"
	else:
		$Price.text = "%s $" % cost
func kup():
	if GlobalVariables.cash >= cost and GlobalVariables.SpeedLevel < cap:
		GlobalVariables.cash -= cost
		GlobalVariables.SpeedLevel += 1
		cost = 200 * (GlobalVariables.SpeedLevel + 1)
		$Price.text = "%s $" % cost
		GlobalVariables.save.emit()
	else:
		if GlobalVariables.cash < cost:
			GlobalVariables.insufficient_funds.emit()
	$Level.text = "LV %s" % GlobalVariables.SpeedLevel
	save.emit()
