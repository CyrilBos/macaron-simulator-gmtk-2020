extends CheckBox


func _on_SoundToggle_toggled(button_pressed):
	AudioServer.set_bus_mute(1, not button_pressed)
