@tool
extends Node3D

@export var mesh_1: MeshInstance3D
@export var color_1: Color = Color(1.0, 0.0, 0.0, 1.0)

func _ready():
	var material = StandardMaterial3D.new()
	material.set_albedo(color_1)
	mesh_1.set_surface_override_material(0, material)
