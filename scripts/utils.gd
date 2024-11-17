extends Node

# Timer
func create_timer(parent: Node, wait_time: float, one_shot = true) -> Timer:
	var timer = Timer.new()
	timer.one_shot = one_shot
	timer.wait_time = wait_time
	parent.add_child(timer)
	return timer


# Node instantiation
func instantiate_node_at_position(node: PackedScene, parent: Node2D, pos: Vector2) -> Node2D:
	var node_instance = instantiate_node(node, parent)
	node_instance.position = pos
	return node_instance


func instantiate_node_at_global_position(node: PackedScene, parent: Node2D, global_pos: Vector2) -> Node2D:
	var node_instance = instantiate_node(node, parent)
	node_instance.global_position = global_pos
	return node_instance


func instantiate_node(node: PackedScene, parent: Node2D) -> Node2D:
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	return node_instance


func get_level_root():
	var scene = get_tree().current_scene.get_node_or_null('/root/Main/World')
	if(is_instance_valid(scene) && scene.get_child_count() > 0):
		return scene.get_child(0)
	
	print_debug("Level root is set as the current scene!")
	return get_tree().current_scene
