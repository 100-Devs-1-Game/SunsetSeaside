extends Node3D
# allows a level to define parameters for its objective par, time limit, etc
# maybe this could be stored somewhere else

#@export var ammo_amount : int # amount of shots able to be taken before reaching the ground
#        ^^^ putting this in the gamestate based on level grouping
@export var ammo_max : int # amount of shots provided to the player

####### goal vars
@export var par_limit : int # amount of shots to be under or at to reach par
@export var time_limit : float

func _ready():
	set_meta(&"Level", self) # for recognition of type by areas, mostly explosive barrels
	
