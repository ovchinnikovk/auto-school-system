[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/admin/all-users-page.ui")]
public class AllUsersPage : Adw.Bin {
    private Gtk.ToggleButton group_button = new Gtk.ToggleButton();

    [GtkChild]
    private unowned Gtk.Box cards_box;

    public override void map() {
        load_content.begin();

        base.map();
    }

    private async void load_content() {
        var users = yield UserManager.instance.get_users();
        yield clear_box();

        foreach (var user in users) {
            var card = new UserCard.with_data(
                user.id,
                user.name,
                user.surname,
                user.patronym,
                user.phone,
                user.email,
                user.telegramId,
                user.aboutMe
            );
            card.user_deleted.connect(() => {
                load_content.begin();
            });
            card.group = group_button;
            cards_box.append(card);
        }
    }

    private async void clear_box() {
        var childs = new Gee.ArrayList<Gtk.Widget>();

        for (var child = cards_box.get_first_child();
        child != null;
        child = child.get_next_sibling())
        childs.add(child);

        foreach (var child in childs)
            cards_box.remove(child);
    }
}
