[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/admin/add-user-page.ui")]
public class AddUserPage : Gtk.Box {
    public string name { get { return name_entry.get_buffer().get_text(); } }
    public string surname { get { return surname_entry.get_buffer().get_text(); } }
    public string patronymic { get { return patronimyc_entry.get_buffer().get_text(); } }
    public string email { get { return email_entry.get_buffer().get_text(); } }
    public string telegram_id { get { return telegram_id_entry.get_buffer().get_text(); } }
    public string password { get { return password_entry.get_text(); } }
    public string role { get; set; }

    [GtkChild]
    private unowned Gtk.Entry name_entry;
    [GtkChild]
    private unowned Gtk.Entry surname_entry;
    [GtkChild]
    private unowned Gtk.Entry patronimyc_entry;
    [GtkChild]
    private unowned Gtk.Entry email_entry;
    [GtkChild]
    private unowned Gtk.Entry telegram_id_entry;
    [GtkChild]
    private unowned Gtk.PasswordEntry password_entry;

    [GtkCallback]
    private async void add_user(){
        var user = new User.common(
            name,
            surname,
            patronymic,
            email,
            telegram_id
        );

        yield UserManager.instance.add_user(user);
        new AddUserDialog().present(this);
    }
}
