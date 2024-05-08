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
	#var grid_size =Vector3(1, 1, 1)w
	# Compute the grid position based on block sizevv
	#var grid_position = object.transform.origin.snapped(Vector3(0.5, 0.5, 0.5)) +(hit_normal.snapped(Vector3(0.5, 0.5, 0.5))* grid_size ) 
	var grid_position = (hit_normal.snapped(Vector3(0.5, 0.5, 0.5))* grid_size ) 
	debugger([grid_position,object.transform.origin.snapped(Vector3(0.5, 0.5, 0.5)),hit_normal.snapped(Vector3(0.5, 0.5, 0.5))])
	#debugger([object.transform.origin.floor() , hit_normal.floor()])
	# Check if there is already a block at this position (optional, depending on your design)
	for child in grid_container.get_children():
		if child.global_transform.origin == grid_position:
			return # Block already exists at this positiondw

	# Instance the block--
	var block_instance = load(scene).instantiate()
	block_instance.transform.origin = grid_position
	# Add the block instance to the current node or another parent node
	var st = SurfaceTool.new()
	var colmesh = get_node("grid_body_collision").get_shape().get_debug_mesh ( )
	var block_mesh = block_instance.mesh

	colmesh.mesh=combineMeshes( [block_mesh, colmesh])

	#st.create_from(colmesh.mesh, 0)
	#st.create_from(block_instance.mesh, 0)
	#st.generate_normals()
	#var ar_mesh = st.commit()
	#self.mesh=ar_mesh
	#
	grid_container.add_child(block_instance)

func combineMeshes(meshes: Array):
	print("Stitching %s meshes" % meshes.size())
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for instance in meshes:
		assert(instance is MeshInstance3D, "not given a MeshInstance3D")
		surfaceTool.append_from(instance.mesh, 0, instance.transform)
		
	surfaceTool.generate_normals()
	return surfaceTool.commit()
	
#func remove_block(scene,hit_normal,object):
	#var grid_size =Vector3(-0.5, -0.5, -0.5)
	##var grid_size =Vector3(1, 1, 1)w
	## Compute the grid position based on block size
	#var grid_position = hit_normal *grid_size
	#debugger([object.get_path()])
	#grid_container.remove_child(object)
