extends LineEdit

const CRUMB_SCENE = preload("res://scenes/crumb.tscn")
const HEART_SCENE = preload("res://scenes/heart.tscn")
const ASH_SCENE = preload("res://scenes/ash.tscn")
const MIA_SCENE = preload("res://scenes/mia.tscn")

var intensity = 3
var crumb
var num_particles = 200
var toast_made = 0 

func _ready():
	%FirstToast.apply_impulse(Vector2(0,-1000))
	%Toaster.get_node("Sound").play()
	
func _input(event):
	if Input.is_action_just_pressed("enter"):
		make_toast()
		
func make_toast():
	if toast_made == 1:
		%instructions2.queue_free()
		%instructions.queue_free()
	if %Spawner.text == "ashmialuna":
		crumb = HEART_SCENE.instantiate()
		crumb.description = "i <3 you 
		andy"
		crumb.heart = true
	elif %Spawner.text == "ash":
		crumb = ASH_SCENE.instantiate()
		crumb.description = %Spawner.text
		crumb.heart = true
	elif %Spawner.text == "mia":
		crumb = MIA_SCENE.instantiate()
		crumb.description = %Spawner.text
		crumb.heart = true
	else:
		crumb = CRUMB_SCENE.instantiate()
		crumb.description = %Spawner.text
		text = ""
	
	
	var particles = crumb.get_node("Particles")
	crumb.global_position = %Toaster.global_position
	crumb.apply_impulse(Vector2(randfn(0,200), -1500))  # Pushes right and up
	
	%Toaster.get_node("Sound").pitch_scale = randfn(1,0.1)
	%Toaster.get_node("Sound").play()
	toast_made += 1
	%Toaster.get_node("ToastMade").text = str(toast_made)
	
	
	get_tree().root.add_child(crumb)
	intensity = 1.5 * ( %Priority.value / 100 ) + 1
	particles.amount = 50 + %Priority.value * 10
	var random_color = Color(intensity * randf(),intensity * randf() ,intensity * randf())
	crumb.get_node("Sprite2D").self_modulate = random_color
	
	var gradient = Gradient.new()
	gradient.set_color(0, random_color)
	gradient.set_color(1, Color(random_color.r, random_color.b, random_color.b, 0.0))
	particles.color_ramp = gradient
	if %Priority.value == 100:
		crumb.get_node("Particles").visible = true
		text = ""
