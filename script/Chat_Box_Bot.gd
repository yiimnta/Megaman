extends RichTextLabel

func _on_Timer_Bottom_timeout():
	set_visible_characters(get_visible_characters() + 1)
