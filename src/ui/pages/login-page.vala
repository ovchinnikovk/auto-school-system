[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/login-page.ui")]
public class LoginPage : Adw.Bin {
    public string? email {
        get { return email_entry.get_buffer().get_text(); }
    }
    public string? password {
        get { return password_entry.get_text(); }
    }
    [GtkChild]
    private unowned Gtk.Entry email_entry;
    [GtkChild]
    private unowned Gtk.PasswordEntry password_entry;

    [GtkCallback]
    private async void enter() {
        yield UserManager.instance.get_token(email, password);
    }
}
