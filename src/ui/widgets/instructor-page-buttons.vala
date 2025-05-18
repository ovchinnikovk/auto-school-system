[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/instructor-page-buttons.ui")]
public class InstructorPageButtons : Gtk.Box {
    [GtkCallback]
    private void switch_page(Gtk.ToggleButton button) {
        page_stack.visible_child_name = button.name;
    }
}
