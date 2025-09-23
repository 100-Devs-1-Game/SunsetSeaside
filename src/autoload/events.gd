extends Node


# signals for getting head 
signal add_camera_shake(amount : float) # called by the camera shaker script, connects to player head
signal head_recoil_affect(head_recoil_x, head_recoil_y, camera_shake) # for pushing recoil data from weapons to the head node
signal shotgun_bounce(direction, force)
signal floor_reload()
signal ui_ammo_update(ammo)

signal fire_weapon() # shoots gun!
