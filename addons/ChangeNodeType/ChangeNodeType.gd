tool
extends EditorPlugin

var isHeldDown := false

func _enter_tree():
  pass

func _exit_tree():
  pass

func _input(event):
  if Input.is_key_pressed(KEY_F7):
    if !isHeldDown:
      changeType()
      isHeldDown = true
  else:
    isHeldDown = false

func changeType():
  var nodes : Array = get_editor_interface().get_selection().get_selected_nodes()
  
  for node in nodes:
    changeOneType(node, RigidBody.new())
    
func changeOneType(node : Node, newnode : Node):
  var isRoot : bool = node == get_editor_interface().get_edited_scene_root()
  
  if isRoot:
    changeRootType(node, newnode)
  else:
    changeNonRootType(node, newnode)
    
func changeNonRootType(node : Node, newnode : Node):
  node.get_parent().add_child(newnode)
  newnode.owner = node.get_parent()
  giveProperties(node, newnode)
  for child in node.get_children():
    var newChild = child.duplicate(7)
    newnode.add_child(newChild)
    newChild.owner = newnode.owner
  var namae: String = node.name
  var filenamae: String = node.filename
  node.free()
  newnode.name = namae
  newnode.filename = filenamae
  
func changeRootType(node : Node, newnode : Node):
  var editor : Node = node.get_node("/root/EditorNode")
  giveProperties(node, newnode)
  transferOwnership(node, newnode, newnode)
  editor.set_edited_scene(newnode)
  var namae : String = node.name
  var filenamae : String = node.filename
  node.free()
  newnode.name = namae
  newnode.filename = filenamae
    
func giveProperties(node : Node, newnode : Node):
  for prop in node.get_property_list():
    if newnode.get(prop["name"]) != null:
      newnode.set(prop["name"], node.get(prop["name"]))
      
func transferOwnership(node : Node, newnode : Node, ownerNode : Node):
  if node.get_child_count() == 0:
    return
  
  for child in node.get_children():
    var newChild = child.duplicate(7)
    newnode.add_child(newChild)
    newChild.owner = ownerNode
    transferOwnership(child, newChild, ownerNode)
