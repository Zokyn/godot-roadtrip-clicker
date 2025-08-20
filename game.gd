extends Node2D

@onready var car_object = $Car
@onready var engine_label: Label = $HUD/EngineStateLabel

func _process(delta: float) -> void:
	if car_object.engine_on and not car_object.engine_starting:
		engine_label.text = "On"
	elif not car_object.engine_on and car_object.engine_starting:
		engine_label.text = "Starting" 
	else:
		engine_label.text = "Off"
