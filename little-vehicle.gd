extends RigidBody2D

@export var engine_on: bool = false;
@export var engine_starting: bool = false;
@onready var engine_sound: AudioStreamPlayer2D = $AudioStreamPlayer

var engine_start_stream: AudioStream = preload("res://audios/car-ignition-0.wav")
var engine_running_stream: AudioStream = preload("res://audios/car-engine-on.wav")

@export var speed: float = 300

var volume_fade_factor := 1
var volume_max := 20.00 #decibéis
var volume_min := 5.00  #decibéis


func _ready() -> void:
	engine_on = false;
	engine_starting = false;
	$AnimationPlayer.play("engine_off")
	$AnimationPlayer.stop();

func _physics_process(delta: float) -> void:
	var direction := 0.0
	
	# Forward Movement
	if Input.is_action_pressed("movement_forward"):
		if (not engine_starting and not engine_on):
			turn_engine_on();
		elif (not engine_starting and engine_on):
			direction += 1.0
			
	elif Input.is_action_pressed("movement_backward"):
		#direction += -1.0
		#turn_engine_on(false); 
		if (engine_starting):
			turn_engine_off()
		elif (engine_on and not engine_starting):
			direction += -0.5
		
	linear_velocity.x = direction * speed;

func _process(delta: float) -> void:
	if (engine_starting):
		engine_sound.volume_db -= volume_fade_factor * delta
	elif (engine_on and not engine_starting):
		if(engine_sound.volume_db <= volume_max and engine_sound.volume_db > volume_min):
			engine_sound.volume_db += volume_fade_factor * delta
		elif(engine_sound.volume_db >= volume_min):
			engine_sound.volume_db -= volume_fade_factor * delta
	else:
		engine_sound.volume_db = 0;
	pass

func turn_engine_on() -> void: 
	engine_starting = true;
	$TimerEngineStarting.start()
	engine_sound.stream = engine_start_stream;
	engine_sound.volume_db = volume_max
	engine_sound.play()
	$AnimationPlayer.play("engine_on_animation");
	#engine_on = true;

		
func turn_engine_off() -> void:
	engine_on = false; 
	engine_starting = false; 
	engine_sound.stop()
	$AnimationPlayer.play("engine_off");
	$AnimationPlayer.stop();


func turn_engine_running() -> void:
	engine_on = true;
	engine_sound.stream = engine_running_stream
	engine_sound.volume_db = volume_max
	engine_sound.autoplay = true;
	engine_sound.play()
	$AnimationPlayer.play("running_forward")	

func _on_engine_start_audio_finished() -> void:
	engine_on = true;
	engine_starting = false; 
	
	turn_engine_running()
	pass # Replace with function body.


func _on_engine_starting_timeout() -> void:
	engine_on = true;
	engine_starting = false; 
	
	turn_engine_running()
	pass # Replace with function body.
