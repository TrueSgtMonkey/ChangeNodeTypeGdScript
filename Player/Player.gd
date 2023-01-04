extends KinematicBody

const GRAVITY           := Vector3.DOWN * 30
const MAX_SPEED         := 18.0
const SPEED_INC_AMOUNT  := 1.0
const MOUSE_SENSITIVITY := 0.28

var velocity := Vector3()
var speed := 0.0
var myDelta := 0.0

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
  myDelta = delta
  move()
  move_and_slide(velocity, Vector3.UP, false)
  
func _input(event):
  if Input.is_key_pressed(KEY_ESCAPE):
    get_tree().quit()
    
func _unhandled_input(event):
  if event is InputEventMouseMotion:
    $Pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY * myDelta)
    $Pivot/Camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY * myDelta)
  
func move():
  var inputs := 0
  
  if Input.is_key_pressed(KEY_W):
    velocity = -$Pivot/Camera.global_transform.basis.z
    inputs += 1
  if Input.is_key_pressed(KEY_A):
    velocity = -$Pivot/Camera.global_transform.basis.x
    inputs += 1
  if Input.is_key_pressed(KEY_S):
    velocity = $Pivot/Camera.global_transform.basis.z
    inputs += 1
  if Input.is_key_pressed(KEY_D):
    velocity = $Pivot/Camera.global_transform.basis.x
    inputs += 1
    
  velocity = velocity.normalized() * speed
    
  if inputs == 0:
    velocity = Vector3.ZERO
    speed = 0.0
  else:
    if speed < MAX_SPEED:
      speed += SPEED_INC_AMOUNT
    else:
      speed = MAX_SPEED
