extends RigidBody2D

@export var engine_is_running: bool = false;
@export var engine_starting: bool = false;
@onready var engine_sound: AudioStreamPlayer2D = $AudioStreamPlayer

@onready var Wheels: Area2D = $Wheels;

var engine_start_stream: AudioStream = preload("res://audios/car-ignition-0.wav")
var engine_running_stream: AudioStream = preload("res://audios/car-engine-on.wav")

@export var gravity_factor: int = 0;
@export var speed: float = 300
@export var steer_speed: float = 149
@export var Road: Area2D

var road_rect: Rect2

var on_road;

var volume_fade_factor := 1
var volume_max := 20.00 #decibéis
var volume_min := 5.00  #decibéis

func _ready() -> void:
	gravity_scale = gravity_factor;
	
	engine_is_running = false;
	engine_starting = false;
	
	$AnimationPlayer.play("engine_off")
	$AnimationPlayer.stop();
	
	var road_shape = Road.get_node("CollisionShape2D").shape
	
	if road_shape is RectangleShape2D:
		var pos = Road.global_position;
		road_rect = Rect2(pos - road_shape.extents, road_shape.extents * 2)

func _physics_process(delta: float) -> void:
	var direction := 0.0 # 	x linear velocity
	var steering := 0.0 # 	y liner velocity 
	# Accel Movement -> foward
	if Input.is_action_pressed("movement_forward"):
		if (not engine_starting and not engine_is_running):
			turn_engine_on();
		elif (not engine_starting and engine_is_running):
			direction += 1.0
	
	# Rear Movement <- backward
	elif Input.is_action_pressed("movement_backward"):
		#turn_engine_on(false); 
		if (engine_starting):
			turn_engine_off()
		elif (engine_is_running and not engine_starting):
			direction += -0.5
		

	if on_road and engine_is_running: 
		var movement = Vector2(direction * speed, steering * steer_speed);
	
		var steer_up = global_position + Vector2(position.x, (-1.0 * steer_speed)) * delta
		var steer_down = global_position + Vector2(position.x, (1.0 * steer_speed)) * delta
		
		if Input.is_action_pressed("steering_upwards") and road_rect.has_point(steer_up): 	# Up Steering ^ upwards
				#if (position + (steergin * steer_speed) > road
			steering = -1.0;
		elif Input.is_action_pressed("steering_downwards") and road_rect.has_point(steer_down): 	# Down Steering 
			steering = 1.0;

			#linear_velocity.y = steering * steer_speed;
		else: 
			steering = 0.0;
			
			
		
		linear_velocity.y = steering * steer_speed;
		linear_velocity.x = direction * speed;
	
func _process(delta: float) -> void:
	if (engine_starting):
		engine_sound.volume_db = 1.0
	elif (engine_is_running and not engine_starting):
		if(engine_sound.volume_db <= volume_max and engine_sound.volume_db > volume_min):
			engine_sound.volume_db += volume_fade_factor * delta
		elif(engine_sound.volume_db >= volume_min):
			engine_sound.volume_db -= volume_fade_factor * delta
	else:
		engine_sound.volume_db = 0;

	# Keep master volume down
	$AudioStreamPlayer.volume_db *= 0.5 

	pass

# My Functions

func turn_engine_on() -> void: 
	engine_starting = true;
	$TimerEngineStarting.start()
	engine_sound.stream = engine_start_stream;
	engine_sound.volume_db = volume_max
	engine_sound.play()
	$AnimationPlayer.play("engine_on_animation");
	#engine_is_running = true;

		
func turn_engine_off() -> void:
	engine_is_running = false; 
	engine_starting = false; 
	engine_sound.stop()
	$AnimationPlayer.play("engine_off");
	$AnimationPlayer.stop();


func turn_engine_running() -> void:
	engine_is_running = true;
	engine_sound.stream = engine_running_stream
	engine_sound.volume_db = volume_max
	engine_sound.autoplay = true;
	engine_sound.play()
	$AnimationPlayer.play("running_forward")	

func _on_engine_start_audio_finished() -> void:
	engine_is_running = true;
	engine_starting = false; 
	
	turn_engine_running()
	pass # Replace with function body.


func _on_engine_starting_timeout() -> void:
	engine_is_running = true;
	engine_starting = false; 
	
	turn_engine_running()
	pass # Replace with function body.


func _on_wheels_area_entered(area: Area2D) -> void:
	if (area == Road):
		on_road = true;
	
	pass # Replace with function body.
