extends Node3D

var mesh : ArrayMesh : set = _set_mesh

func _set_mesh(new_mesh):
	mesh = new_mesh
	$MeshInstance3D.mesh = mesh
