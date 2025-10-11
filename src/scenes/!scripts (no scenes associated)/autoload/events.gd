extends Node
# event bus for letting nodes communicate events to eachother

###### player signals
# physics
signal shotgun_bounce(direction, force)
signal explosion_bounce(direction, force, smoke_trail_amount)
# gameplay
signal floor_reload() # reloads the cannon upon touching a surface
signal fire_weapon() # shoots gun!
# camera effects
signal add_camera_shake(amount : float) # called by the camera shaker script, connects to player head
signal head_recoil_affect(head_recoil_x, head_recoil_y, camera_shake) # for pushing recoil data from weapons to the head node

###### gamestate signals
# level setup
signal establish_spawnpoint(node) # establish spawnpoint with the gamestate
signal establish_level_vars(max_ammo, par_limit, time_limit)

# player actions
signal player_death(type : Enums.PlayerDeathType) # read by gamestate, player
signal level_end_reached() # called by ending areas
signal first_movement() # read by gamestate for starting the stopwatch
signal weapon_fired() # called by cannon script on a succesful cannon fire
# menu
signal open_level(grouping : Enums.LevelGrouping, id : int) # called by the main menu script, id in accordance to the menu option chosen

###### ui
signal ui_ammo_update(ammo : int) 
signal ui_shots_taken_update(amount : int)
signal ui_set_level_vars(max_ammo, par_limit, time_limit) # emitted by gamestate to show these values on level startup
