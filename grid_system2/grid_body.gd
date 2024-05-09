extends Interactable
@onready var grid_body = $grid_body
@onready var grid_container = $"."

const BASE_STATIC = "res://grid_system2/Block.tscn"

func _process(delta):
	pass

func _interact_right(_position, object):
	add_block(BASE_STATIC, _position,object)

#func _interact_left(_position, object):
	#remove_block(BASE_STATIC, _position,object)
	#
func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
#
func add_block(scene,hit_normal,object):
	var grid_size =Vector3(0.5, 0.5, 0.5)

	# Compute the grid position based on block size
	var grid_position = (hit_normal.snapped(Vector3(0.5, 0.5, 0.5))* grid_size ) 

	# Check if there is already a block at this position (optional, depending on your design)
	for child in grid_container.get_children():
		if child.global_transform.origin == grid_position:
			return # Block already exists at this positiondw

	# Instance the block
	var block_instance = load(scene).instantiate()
	block_instance.transform.origin = grid_position
	var block_mesh = block_instance.get_node("mesh").mesh
	
	# get collision mesh data
	var colmesh = get_node("grid_body_collision")
	var colmesh_shape = colmesh.get_shape() 
	
	var st = SurfaceTool.new()
	var trans=Transform3D.IDENTITY
	## You need to check if colmesh is valid because CollisionShape doesn't inherently contain a visual mesh
	if colmesh_shape:
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.create_from(colmesh_shape, 0)
		st.append_from(block_mesh, 0, trans.translated(grid_position))
		st.generate_normals()
		var new_mesh = st.commit()
		colmesh.set_shape(new_mesh.create_convex_shape())

	else:
		print("No visual mesh found for the collision shape")

	grid_container.add_child(block_instance)
	#grid_container.add_child(block_instance)
