extends RigidBody2D

@export var engine_on: bool = false;
@export var engine_starting: bool = false;
@onready var engine_sound: AudioStreamPlayer2D = $AudioStreamPlayer

var engine_start_stream: AudioStream = preload("res://audios/car-ignition-0.wav")
var engine_running_stream: AudioStream = preload("res://audios/car-engine-on.wav")

@export var speed: float = 300

var engine_fade_speed := 1
var engine_default_volume_db :=20.00


func _ready() -> void:
	engine_on = false;
	engine_starting = false;
	$AnimationPlayer.play("engine_off")
	$AnimationPlayer.stop();

func _physics_process(delta: float) -> void:
	var direction := 0.0
	
	# Forward Movement
	if Input.is_action_pressed("movement_forward"):
		#direction += 1.0
		if (not engine_starting):
			turn_engine_on();
	elif Input.is_action_pressed("movement_backward"):
		#direction += -1.0
		#turn_engine_on(false); 
		if (engine_on or engine_starting):
			turn_engine_off()
		
	linear_velocity.x = direction * speed;

func _process(delta: float) -> void:
	pass
	#if engine_sound.playing and engine_sound.stream == engine_start_stream:
		#engine_sound.volume_db -= engine_fade_speed * delta;
		#if engine_sound.volume_db <= engine_default_volume_db/0.1: 
			#engine_sound.stop()
			#turn_engine_running()
			
	#elif engine_sound.stream == engine_running_stream:

func turn_engine_on() -> void: 
	engine_starting = true;
	engine_sound.stream = engine_start_stream;
	engine_sound.volume_db = engine_default_volume_db
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
	engine_sound.volume_db = engine_default_volume_db
	engine_sound.autoplay = true;
	engine_sound.play()

func _on_engine_start_audio_finished() -> void:
	engine_on = true;
	engine_starting = false; 
	
	turn_engine_running()
	pass # Replace with function body.
