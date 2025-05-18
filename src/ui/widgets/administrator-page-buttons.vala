[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/administrator-page-buttons.ui")]
public class AdministratorPageButtons : Gtk.Box {
    [GtkCallback]
    private void switch_page(Gtk.ToggleButton button) {
        page_stack.visible_child_name = button.name;
    }
}
