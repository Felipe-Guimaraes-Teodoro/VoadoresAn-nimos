extends Node2D

# Caminho para nossa cena principal
@export_file("*.tscn") var main_game_scene: String = "res://node_3d.tscn"

func _ready():
	# Mantém o mouse visível
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	$jogar.grab_focus()
	
	$jogar.pressed.connect(start_game)
	$sair.pressed.connect(exit_game)

func start_game():
	get_tree().change_scene_to_file(main_game_scene)

func exit_game():
	get_tree().quit()
