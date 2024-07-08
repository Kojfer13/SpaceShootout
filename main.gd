extends Node

var lives
var diff = 0
var difflvl = 1
var spawn_count = 1
var shield = GlobalVariables.ShieldLevel

func _ready():               
	GlobalVariables.save.connect(save)
	GlobalVariables.WhereAmI = 0
	print("Gdzie Jestem = 0 w ready")
	$ShootDelay.stop()
	$SpawnDelay.stop()
	get_tree().set_auto_accept_quit(false)
	wczytaj()
	menu()
func menu():
	GlobalVariables.WhereAmI = 0
	odpauzuj()
	print("Gdzie Jestem = 0 w menu")
	$ShootDelay.stop()
	$SpawnDelay.stop()
	get_tree().call_group("przeciwnicy", "queue_free")
	get_tree().call_group("naboje", "queue_free")
	$UI.hide_pause() 
	$UI/Credits.hide()
	$UI.show_menu()
	$UI.hide_hud()
	$UI.hide_gameover()
	$UI/Sklep.hide()
	$Tlo.hide()
	$Gracz.hide()
	$SpaceshipControl.hide()
	$SpawnSound.stop()
func start():
	spawn_count = 1
	GlobalVariables.WhereAmI = 1
	print("Gdzie Jestem = 1 w start")
	lives = 5
	$ShootDelay.wait_time = 0.5  - GlobalVariables.SpeedLevel * 0.05
	$SpawnDelay.wait_time = 1.5
	$UI.score = -100
	$UI.update_score() 
	$UI.update_lives(lives)
	if GlobalVariables.ShieldLevel > 0:
		shield = GlobalVariables.ShieldLevel
		$UI.update_shield(shield)
		$UI.show_shield()
	else:
		$UI.hide_shield()
	$UI.hide_menu()
	$UI.hide_gameover()
	$UI.show_hud()
	$Gracz.show()
	$Tlo.show()
	$SpaceshipControl.value = 480 / 2
	$SpaceshipControl.show()
	$ShootDelay.start()
	$SpawnDelay.start()
	$DiffTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Gracz.position.x = $SpaceshipControl.value

func shoot():
	var bullet = preload("res://bullet.tscn").instantiate()
	bullet.position.x = $Gracz.position.x
	bullet.position.y = $Gracz.position.y - 100
	bullet.linear_velocity = Vector2(0, -900)
	add_child(bullet)
	$SpawnSound.play()

func spawn():
	for i in spawn_count:
		var enemy = preload("res://kwadrat.tscn").instantiate()
		enemy.position.y = -500
		enemy.position.x = randi() % 1080
		enemy.linear_velocity = Vector2(0, 500)
		enemy.DefPos.connect(emit_cash_particle)
		add_child(enemy)
		enemy.point.connect($UI.update_score)
		enemy.cash.connect(GlobalVariables.Update_Cash)
		enemy.poza.connect(uderzono)
	$SpawnDelay.wait_time = 1
func emit_cash_particle(where):
	var sto = preload("res://cashparticle.tscn").instantiate()
	sto.position = where
	add_child(sto)
func uderzono():
	print("Życia: ", lives, " Tarcza: ", shield)
	if shield > 0:
		shield -= 1
		$UI.update_shield(shield)
		$ShieldTimer.start()
		if shield == 0:
			$UI.hide_shield()
		return
	lives -= 1
	$UI.update_lives(lives)
	if lives <= 0:
		GlobalVariables.WhereAmI = 0
		print("Gdzie Jestem = 0 w gameover")
		get_tree().call_group("przeciwnicy", "queue_free")
		get_tree().call_group("naboje", "queue_free")
		$UI.hide_hud()
		$ShootDelay.stop()
		$SpawnDelay.stop()
		$UI.gameover()
		save()
		$UI.score = 0
func save():
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data = $UI.call("saved")
	print("read:")
	print(data)
	var json_string = JSON.stringify(data)
	print("write:")
	print(json_string)
	save.store_line(json_string)
func wczytaj():
	if not FileAccess.file_exists("user://savegame.save"):
		print("BRAK save")
		return
	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	print("PLIK save ODNALEZIONY")
	var json = JSON.new()
	var parse = json.parse(save.get_line())
	var temp = {
		"highscore" : 0,
		"cash" : 0,
		"SpeedLv" : 0,
		"MoneyLv" : 0,
		"ShieldLv" : 0,
		"OwnedSkins" : [true, false, false, false, false, false, false, false, false, false],
		"EquippedSkin" : 0
	}
	var data = json.get_data()
	data.merge(temp, false)
	print("Merged: ", data)
	if data == null:
		print("PLIK save USZKODZONY")
		return
	print("odczytano: ", data)
	$UI.highscore =  int(data["highscore"])
	GlobalVariables.cash = int(data["cash"])
	GlobalVariables.SpeedLevel = int(data["SpeedLv"])
	GlobalVariables.MoneyLevel = int(data["MoneyLv"])
	GlobalVariables.ShieldLevel = int(data["ShieldLv"])
	GlobalVariables.OwnedSkins = Array(data["OwnedSkins"])
	GlobalVariables.EquippedSkin = int(data["EquippedSkin"])
	GlobalVariables.EquipSkin.emit(GlobalVariables.EquippedSkin)
	print("Załadowany wynik: ", int($UI.highscore))
	print("Załadowane pieniądze: ", int(GlobalVariables.cash))
	print("Posiadata Skiny", GlobalVariables.OwnedSkins)
	print("Obecny Skin", GlobalVariables.EquippedSkin)
	
func _notification(what): 
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			#Debug
			match GlobalVariables.WhereAmI: 
				0:
					print("JESTEM W 0")
					save()
					get_tree().quit()
				1:
					pause()
				2:
					odpauzuj()
				3:
					$UI.hide_store()
				4:
					$UI.hide_credits()
				_:
					pass
					
		NOTIFICATION_WM_GO_BACK_REQUEST:
			#Android
			match GlobalVariables.WhereAmI: 
				0:
					get_tree().quit()
				1:
					pause()
				2:
					odpauzuj()
				3:
					$UI.hide_store()
				4:
					$UI.hide_credits()
				_:
					print("NIC wartosc: ", GlobalVariables.WhereAmI)

func pause():
	$UI.show_pause()
	GlobalVariables.WhereAmI = 2
	print("Gdzie Jestem = 2 w pauze")
	get_tree().paused = true

func odpauzuj():
	if GlobalVariables.WhereAmI == 0:
		get_tree().paused = false
		return
	$UI/PauseScreen.hide()
	GlobalVariables.WhereAmI = 1
	print("Gdzie Jestem = 1 w odpauzuj")
	get_tree().paused = false
func _on_diff_timer_timeout():
	diff = 0.1
	if $SpawnDelay.wait_time != 0.6:
		$SpawnDelay.wait_time = 1 - diff
		print("Zmiana spawn time:", $SpawnDelay.wait_time)
	else:
		difflvl += 1
		print("Difflvl = ", difflvl)
		if difflvl == 5:
			spawn_count = 2
			print("Zmiana spawn count:", spawn_count)


func regeneruj():
	if shield < GlobalVariables.ShieldLevel:
		shield += 1
		if shield == 1:
			$UI.show_shield()
		if shield <= GlobalVariables.ShieldLevel:
			$ShieldTimer.start()
