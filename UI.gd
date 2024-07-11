extends CanvasLayer

signal start
signal menu
signal retry
signal save
signal unpause
signal pause
signal refresh

var score = 0
var highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func saved():
	var save_dict = {
		"highscore" : highscore,
		"cash" : GlobalVariables.cash,
		"SpeedLv" : GlobalVariables.SpeedLevel,
		"MoneyLv" : GlobalVariables.MoneyLevel,
		"ShieldLv" : GlobalVariables.ShieldLevel,
		"OwnedSkins" : GlobalVariables.OwnedSkins,
		"EquippedSkin" : GlobalVariables.EquippedSkin
	}
	return save_dict
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _on_start_button_pressed():
	emit_signal("start")
func hide_menu():
	$TitleScreen.hide()
func show_menu():
	$TitleScreen.show()
func show_hud():
	$Hud.show()
func hide_hud():
	$Hud.hide()
func gameover():
	#$GameOver/ScoreValue.text = str(score)
	$GameOver/ScoreText.text = "Twój wynik to: %s " % score
	if score > highscore:
		highscore = score
		save.emit()
	$GameOver/HighScoreText.text = "Twój najlepszy wynik to: %s" % highscore
	$GameOver.show()
func hide_gameover():
	$GameOver.hide()
func update_lives(wynik):
	$Hud/LivesDisplay.text = str(wynik)
func update_shield(wynik):
	$Hud/ShieldDisplay.text = str(wynik)
func show_shield():
	$Hud/Shield.show()
	$Hud/ShieldDisplay.show()
func hide_shield():
	$Hud/Shield.hide()
	$Hud/ShieldDisplay.hide()
func update_score():
	score += 100
func show_pause():
	$PauseScreen.show()
func hide_pause():
	print("odpauza")
	$PauseScreen.hide()
	unpause.emit()
func _on_menu_pressed():
	emit_signal("menu")
func _on_retry_pressed():
	emit_signal("retry")
func _on_pause_button_pressed():
	pause.emit()
func show_store():
	refresh.emit()
	$Sklep.show()
	GlobalVariables.WhereAmI = 3
func hide_store():
	$Sklep.hide()
	GlobalVariables.WhereAmI = 0
func show_credits():
	$Credits.show()
	GlobalVariables.WhereAmI = 4
func hide_credits():
	$Credits.hide()
	GlobalVariables.WhereAmI = 0
func show_codes():
	$CodeScreen.show()
	GlobalVariables.WhereAmI = 5
func hide_codes():
	$CodeScreen.hide()
