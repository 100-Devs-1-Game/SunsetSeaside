extends Resource
class_name Level_Info

@export var name : String
@export var time_limit : float = -1.0
@export var par : int = -1 # negatives indicate no value
@export_subgroup("paths")
@export var level_path : String
@export var image_path : String
