tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("CSS Grid Container", "Container", preload("grid_container.gd"), preload("Icon.png"))
    add_custom_type("CSS Grid Area", "Container", preload("grid_area.gd"), preload("Icon.png"))

func _exit_tree():
    remove_custom_type("CSS Grid Container")
    remove_custom_type("CSS Grid Area")
