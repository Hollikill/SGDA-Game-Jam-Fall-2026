@tool
extends EditorPlugin

const HOTKEY := KEY_F

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey: return
	if not event.pressed or event.echo: return
	if event.keycode != HOTKEY: return
	if not event.shift_pressed: return

	var selection := get_editor_interface().get_selection()
	var nodes := selection.get_selected_nodes()

	for node in nodes:
		var parent := node.get_parent()
		if parent in nodes:
			continue
		node.scale.x *= -1
