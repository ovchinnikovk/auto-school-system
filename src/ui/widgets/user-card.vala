[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/user-card.ui")]
public class UserCard : Gtk.Box {
    public Bytes bytes { get; set; }
    public int id { get; set; }
    public string? name { get; set; }
    public string? surname { get; set; }
    public string? patronymic { get; set; }
    public string? number { get; set; }
    public string? email { get; set; }
    public string? telegram_id { get; set; }
    public string? about_me { get; set; }
    public Gtk.ToggleButton group { get; set; }

    [GtkChild]
    private unowned Gtk.Revealer revealer;

    public signal void user_deleted();

    public UserCard.with_data(
        int id,
        string? name,
        string? surname,
        string? patronymic,
        string? number,
        string? email,
        string? telegram_id,
        string? about_me
    ) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.patronymic = patronymic;
        this.number = number;
        this.email = email;
        this.telegram_id = telegram_id;
        this.about_me = about_me;
    }

    [GtkCallback]
    private async void reveal(Gtk.ToggleButton button) {
        revealer.reveal_child = button.active;
    }

    [GtkCallback]
    private async void edit() {}

    [GtkCallback]
    private async void delete() {
        yield UserManager.instance.delete_user(id);
        message("delete");
        user_deleted();
        unparent();
    }
}
