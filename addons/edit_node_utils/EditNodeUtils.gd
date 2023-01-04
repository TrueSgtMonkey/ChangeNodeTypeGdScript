tool
extends EditorPlugin

func _input(event):
  if Input.is_key_pressed(KEY_F7):
    var nodes = get_editor_interface().get_selection().get_selected_nodes()
    
func changeType(node : Node, newNode : Node):
  pass
