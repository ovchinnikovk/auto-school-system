public static Gtk.Stack page_stack;

[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/main-page.ui")]
public class MainPage : Adw.Bin {
    [GtkChild]
    private unowned Gtk.Stack pages_stack;
    [GtkChild]
    private unowned Gtk.Stack button_stack;

    construct {
        page_stack = this.pages_stack;

        users.user_loaded.connect((user) => {
            button_stack.visible_child_name = user.roles[0];
        });
    }
}
