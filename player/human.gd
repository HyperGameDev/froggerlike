extends Node3D

var projectile_interval_min : float = .1
var projectile_interval_max : float = 4.0

@onready var projectile_interval_timer : Timer = Timer.new()
@onready var animation: AnimationTree = %AnimationTree
var skeleton: Skeleton3D
var bone_index: int = 3
var target: CharacterBody3D

var is_enemy: bool = false

func _ready() -> void:
	Messenger.is_enemy.connect(_on_is_enemy)
	if is_enemy:
		setup_timer()

func setup_timer():
	projectile_interval_timer.timeout.connect(on_projectile_interval_timeout)
	projectile_interval_timer.one_shot = true
	add_child(projectile_interval_timer)
	projectile_interval_timer.start(1)
	
func on_projectile_interval_timeout():
	projectile_interval_timer.start(1)
	
	var bullet := preload("res://enemies/human_projectile_01.tscn").instantiate()
	print("Tried to shoot")
	
	get_parent().add_child(bullet)
	bullet.global_position = %point_marker.global_position
	
	if not Player.ref == null:
		bullet.target.global_position = Player.ref.global_position
		bullet.look_at(Player.ref.global_position)

func _on_is_enemy():
	skeleton = get_node("human_03_00_GIANT/Armature/Skeleton3D")
	is_enemy = true
	animation.set("parameters/PISTOL/blend_amount", 1.0)
	get_node("human_03_00_GIANT/Armature/Skeleton3D/Gun_Pistol").visible = true
	
	setup_timer()
	
func _physics_process(delta: float) -> void:
	if is_enemy:
		if not Player.ref == null:
			target = Player.ref
			aim_bone_at_target(bone_index, target, 1.0, false)
		
func aim_bone_at_target(bone_index:int, target:Node3D, amount:float, reset:bool):
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	
	if reset:
		skeleton.set_bone_global_pose_override(bone_index, bone_transform, amount, false)
		return

	var target_pos: Vector3 = skeleton.to_local(target.global_position)
	var direction = (target_pos - bone_transform.origin).normalized()
	
	var new_transform: Transform3D = bone_transform
	
	new_transform = transform_look_at(new_transform, direction)
	skeleton.set_bone_global_pose_override(bone_index, new_transform, amount, true)

func transform_look_at(_transform: Transform3D, direction: Vector3) -> Transform3D:
	var xform: Transform3D = _transform
	xform.basis.z = direction
	
	xform.basis.x = xform.basis.y.cross(direction).normalized()
	xform.basis.y = xform.basis.z.cross(xform.basis.x).normalized()
	xform.basis = xform.basis.orthonormalized()
	return xform
