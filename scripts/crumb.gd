extends RigidBody2D

var grabbed := false
var grab_offset:Vector2
var target_position = Vector2.ZERO 
var deadline
var priority = 0
var heart = false
@export var description = "lorem ipsum"

const HEART_TEXTURE = preload("res://assets/sprites/heartparticle.png")

func _ready():
	$Sprite2D/Description.text = description
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	
func _process(delta):
	var in_range = (get_global_mouse_position() - global_position).length() < 60
	if (Input.is_action_pressed("pop") && (grabbed || in_range)) || (Input.is_action_pressed("popall") ):
			$ProgressBar.value += 1 * delta
			$AnimationPlayer.speed_scale = $ProgressBar.value
	if not Input.is_action_pressed("pop") and not(Input.is_action_pressed("popall")):
		$ProgressBar.value -= 1 * delta
		$AnimationPlayer.speed_scale = $ProgressBar.value
	if $ProgressBar.value == 3:
		explode()
			
func _input(event): 
	var in_range = (get_global_mouse_position() - global_position).length() < 60
	if (in_range):
		if Input.is_action_just_pressed("grab"):
					if (in_range):
						rotation = 0
						grabbed = true
						grab_offset = global_position - get_global_mouse_position()			
		if Input.is_action_just_pressed("release"):
			grabbed = false
			print("released")
		if Input.is_action_just_pressed("delete"):
			queue_free()
		if Input.is_action_pressed("pop"):
			pop()
	elif Input.is_action_pressed("popall"):
		pop()
		
func _physics_process(delta):
	if grabbed:
		var target = get_global_mouse_position() + grab_offset
		var direction = (target - global_position)
		linear_velocity = direction * 5.0
		angular_velocity = 0.0
		if Input.is_action_just_pressed("zoom+"):
			grow()
		if Input.is_action_just_pressed("zoom-"):
			shrink()
			
func explode():
	
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.get_node("Particles").color_ramp = $Particles.color_ramp
	
	get_parent().add_child(explosion)
	explosion.get_node("Particles").amount = $Particles.amount
	explosion.global_position = global_position
	explosion.get_node(("Particles")).emitting = true
	if heart: 
		explosion.get_node(("Particles")).texture = HEART_TEXTURE
		explosion.get_node("Particles").scale_amount_max = $Particles.scale_amount_max 
		explosion.get_node("Particles").scale_amount_min = $Particles.scale_amount_min 
	else:
		explosion.get_node("Particles").scale_amount_max = $Particles.scale_amount_max
		explosion.get_node("Particles").scale_amount_min = $Particles.scale_amount_min
	# Delete this object immediately
	explosion.get_node("Sound").pitch_scale = randfn(1,0.15)
	queue_free()

func pop():
	if not($AnimationPlayer.is_playing()):
		$AnimationPlayer.play("new_animation")
		
func shrink():
	var scale_factor = 0.5
	var tween = create_tween()
	tween.set_parallel(true)
	
	var new_sprite_scale = $Sprite2D.scale * scale_factor
	tween.tween_property($Sprite2D, "scale", new_sprite_scale, 0.5)
	$Particles.scale_amount_min -= 1
	$Particles.scale_amount_max -= 5
	tween.tween_property($Particles, "scale", new_sprite_scale, 0.5)
	if $CollisionShape2D.shape is CircleShape2D:
		var new_radius = $CollisionShape2D.shape.radius * scale_factor
		tween.tween_property($CollisionShape2D.shape, "radius", new_radius, 0.5)
	elif $CollisionShape2D.shape is RectangleShape2D:
		tween.tween_property($CollisionShape2D.shape, "size", 
		$CollisionShape2D.shape.size * 0.5, 0.5)


func grow():
	var scale_factor = 1.5
	var tween = create_tween()
	tween.set_parallel(true)
	
	var new_sprite_scale = $Sprite2D.scale * scale_factor
	tween.tween_property($Sprite2D, "scale", new_sprite_scale, 0.5)
	$Particles.scale_amount_min += 1
	$Particles.scale_amount_max += 5
	tween.tween_property($Particles, "scale", new_sprite_scale, 0.5) 
	if $CollisionShape2D.shape is CircleShape2D:
		var new_radius = $CollisionShape2D.shape.radius * scale_factor
		tween.tween_property($CollisionShape2D.shape, "radius", new_radius, 0.5)
	elif $CollisionShape2D.shape is RectangleShape2D:
		tween.tween_property($CollisionShape2D.shape, "size", 
			$CollisionShape2D.shape.size * 1.5, 0.5)
