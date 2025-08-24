extends Node2D

@onready var Car = $Car
@onready var Road = $Road
@onready var engine_label: Label = $HUD/EngineStateLabel

func _process(delta: float) -> void:
	if Car.engine_is_running and not Car.engine_starting:
		engine_label.text = "On"
	elif not Car.engine_is_running and Car.engine_starting:
		engine_label.text = "Starting" 
	else:
		engine_label.text = "Off"


func _on_engine_starting_timeout() -> void:
	pass # Replace with function body.
