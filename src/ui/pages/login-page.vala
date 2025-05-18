[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/login-page.ui")]
public class LoginPage : Adw.Bin {
    public string? email {
        get { return email_entry.get_buffer().get_text(); }
    }
    public string? password {
        get { return password_entry.get_text(); }
    }
    public string? error { get; set; }
    [GtkChild]
    private unowned Gtk.Entry email_entry;
    [GtkChild]
    private unowned Gtk.PasswordEntry password_entry;
    [GtkChild]
    private unowned Gtk.Revealer error_revealer;

    construct {
        UserManager.instance.error_authentication.connect((err) => {
            error = err;
            error_revealer.reveal_child = true;

            Timeout.add_once(3000, reveal_error);
        });

        UserManager.instance.user_loaded.connect(() => {
            stack.visible_child_name = "main_page";
        });
    }

    private void reveal_error() {
        error_revealer.reveal_child = false;
    }

    [GtkCallback]
    private async void enter() {
        yield UserManager.instance.get_me(email, password);
    }
}
