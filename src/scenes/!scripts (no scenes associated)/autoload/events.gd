extends Node
# event bus for letting nodes communicate events to eachother

###### signals for getting head 
signal add_camera_shake(amount : float) # called by the camera shaker script, connects to player head
signal head_recoil_affect(head_recoil_x, head_recoil_y, camera_shake) # for pushing recoil data from weapons to the head node

###### movement signals
signal shotgun_bounce(direction, force)
signal explosion_bounce(direction, force, smoke_trail_amount)

###### weapon signals
signal floor_reload() # reloads the cannon upon touching a surface
signal fire_weapon() # shoots gun!

###### gamestate signals
signal establish_spawnpoint(node) # establish spawnpoint with the gamestate
signal player_death(type : Enums.PlayerDeathType) # read by gamestate, player
signal level_end_reached() # called by ending areas
signal first_movement() # read by gamestate for starting the stopwatch
signal weapon_fired() # called by cannon script on a succesful cannon fire

###### ui labels
signal ui_ammo_update(ammo : int) 
signal ui_shots_taken_update(amount : int)
