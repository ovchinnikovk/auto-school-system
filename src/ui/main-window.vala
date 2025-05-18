public static unowned Gtk.Stack stack;

[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/main-window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Gtk.Stack main_stack;

    public MainWindow(Gtk.Application app) {
        Object(application: app);

        maximized = true;
    }

    construct {
        stack = main_stack;
    }

    public static void ensure_types() {
        typeof(MainPage).ensure();
        typeof(LoginPage).ensure();

        typeof(StudentPageButtons).ensure();
        typeof(AdministratorPageButtons).ensure();
        typeof(TeacherPageButtons).ensure();
        typeof(InstructorPageButtons).ensure();
    }
}
