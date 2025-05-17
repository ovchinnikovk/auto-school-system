public unowned Adw.NavigationView main_nav;

[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/main-window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Adw.NavigationView nav_view;

    public MainWindow(Gtk.Application app) {
        Object(application: app);

        maximized = true;
    }

    construct {
        main_nav = nav_view;
    }

    public static void ensure_types() {
        typeof(MainPage).ensure();
        typeof(TextField).ensure();
    }
}
