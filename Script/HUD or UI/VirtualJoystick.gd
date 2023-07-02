extends Control


var start_input_pos = Vector2.ZERO
var end_input_pos = Vector2.ZERO
var direction = Vector2.ZERO

var draging_id = -1

var is_pressed = false
var is_working = false
var force = 0
const max_force = 60

signal swipe_begin(direction, force)
signal swipe_end()
var other_joystick

onready var touch_button = $TouchScreenButton
onready var line_UI = $Line2D

func _ready():
	touch_button.shape.radius = max_force

func _input(event):
	if is_working:
		if other_joystick == null and StageInfo.play_co_op:
			for i in get_tree().get_nodes_in_group("Joystick"):
				if i != self:
					other_joystick = i
		if event is InputEventScreenDrag:
			if StageInfo.play_co_op:
				if event.get_index() != other_joystick.draging_id:
					get_draging_id(event)
					update_end_pos(event)
			else:
				get_draging_id(event)
				update_end_pos(event)

func get_draging_id(event):
	if is_pressed:
		return
	is_pressed = true
	if StageInfo.play_co_op:
		if event.index != other_joystick.draging_id:
			draging_id = event.index
	else:
		draging_id = event.index
	start_input_pos = touch_button.global_position

func update_end_pos(event):
	if event.index == draging_id:
		end_input_pos = event.position
		var value = start_input_pos - end_input_pos
		direction = value.normalized()
		force = value.length()
		if force > max_force:
			force = max_force
		line_UI.points[1].x = -force
		line_UI.rotation = value.angle()
	pass

func _process(delta):
	if not is_working: return
	else: emit_signal("swipe_begin", direction, force)
		

func _on_TouchScreenButton_pressed():
	is_working = true
	pass # Replace with function body.


func _on_TouchScreenButton_released():
	is_working = false
	is_pressed = false
	draging_id = -1
	force = 0
	direction = Vector2.ZERO
	end_input_pos = Vector2.ZERO
	start_input_pos = Vector2.ZERO
	line_UI.points[1] = Vector2.ZERO
	emit_signal("swipe_end")
	pass # Replace with function body.
