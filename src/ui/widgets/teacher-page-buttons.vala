[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/teacher-page-buttons.ui")]
public class TeacherPageButtons : Gtk.Box {
    [GtkCallback]
    private void switch_page(Gtk.ToggleButton button) {
        page_stack.visible_child_name = button.name;
    }
}
