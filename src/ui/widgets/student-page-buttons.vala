[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/student-page-buttons.ui")]
public class StudentPageButtons : Gtk.Box {
    [GtkCallback]
    private void switch_page(Gtk.ToggleButton button) {
        page_stack.visible_child_name = button.name;
    }
}
