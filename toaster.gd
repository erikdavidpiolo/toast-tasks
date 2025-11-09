extends RigidBody2D

var grabbed = false
var grab_offset:Vector2

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


func _physics_process(delta):
	if grabbed:
		var target = get_global_mouse_position() + grab_offset
		var direction = (target - global_position)
		linear_velocity = direction * 5.0
		angular_velocity = 0.0
