[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/user-card.ui")]
public class UserCard : Gtk.Box {
    public Bytes bytes { get; set; }
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

    public UserCard.with_data(
        string? name,
        string? surname,
        string? patronymic,
        string? number,
        string? email,
        string? telegram_id,
        string? about_me
    ) {
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
}
