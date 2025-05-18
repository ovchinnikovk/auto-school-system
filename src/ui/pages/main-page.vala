public static Gtk.Stack page_stack;

[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/main-page.ui")]
public class MainPage : Adw.Bin {
    [GtkChild]
    private unowned Gtk.Stack pages_stack;
    [GtkChild]
    private unowned Gtk.Stack button_stack;

    construct {
        page_stack = this.pages_stack;

        UserRepository.instance.user_loaded.connect(() => {
            button_stack.visible_child_name =
                UserRepository.instance.me.roles[0];
        });
    }
}
