extends Node
# event bus for letting nodes communicate events to eachother

###### player signals
# physics
signal shotgun_bounce(direction, force)
signal explosion_bounce(direction, force, smoke_trail_amount)
signal net_bounce(net_normal)
# gameplay
signal floor_reload() # reloads the cannon upon touching a surface
signal wall_reload() # reloads the cannon partially on walls
signal fire_weapon() # shoots gun!
# camera effects
signal add_camera_shake(amount : float) # called by the camera shaker script, connects to player head
signal head_recoil_affect(head_recoil_x, head_recoil_y, camera_shake) # for pushing recoil data from weapons to the head node
signal fps_mouse_movement(event)

###### gamestate signals
# level setup
signal establish_spawnpoint(node) # establish spawnpoint with the gamestate
signal establish_level_vars(max_ammo, par_limit, time_limit)
signal entity_reset() # called by the gamestate on respawn

# player actions
signal player_death(type : Enums.PlayerDeathType) # read by gamestate, player
signal level_end_reached() # called by ending areas
signal first_movement() # read by gamestate for starting the stopwatch
signal weapon_fired() # called by cannon script on a succesful cannon fire
signal jug_collected() # jug get!
# main
signal open_level(grouping : Enums.LevelGrouping, id : int) # called by the main menu script, id in accordance to the menu option chosen
signal open_menu(menu : Enums.Menus)
signal close_menu()
signal queue_menu_package(grouping, id, menu)

###### ui
signal ui_ammo_update(ammo : int) 
signal ui_shots_taken_update(amount : int)
signal ui_set_level_vars(max_ammo, par_limit, time_limit) # emitted by gamestate to show these values on level startup
signal ui_send_end_results(time, time_limit, shots_taken, par_limit, jug_grabbed) # sends these values to the ending screen to be displayed after calc
signal ui_send_level_history(time_best, shots_best, jug_history, hardcore_history) # split into two methods for ease
signal ui_update_title_state(state)

###### settings
signal set_sens(sensitivity : float) # done
signal set_crouch_toggle(toggled : bool) # needs code in player script
signal set_labels_hidden(hidden : bool) # done
signal set_master_vol(vol : int) # done
signal set_sfx_vol(vol : int) # done
signal set_music_vol(vol : int) # done
signal set_ambient_vol(vol : int) # done
signal set_fov(fov : int) # done
signal set_fullscreen(fullscreen : bool) # done?
signal set_4by3(fourbythree : bool) # currently unused
signal set_reso_scale(multi : int) # currently unused
