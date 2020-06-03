extends RichTextLabel

func _on_Timer_Top_timeout():
	set_visible_characters(get_visible_characters() + 1)
