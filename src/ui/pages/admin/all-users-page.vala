[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/admin/all-users-page.ui")]
public class AllUsersPage : Adw.Bin {
    private ListStore list = new ListStore(typeof(User));

    [GtkChild]
    private unowned Gtk.ListBox cards_box;

    construct {
        cards_box.bind_model(list, object => {
            var user = (User) object;
            var card = new UserCard.with_data(
                user.name,
                user.surname,
                user.patronym,
                user.phone,
                user.email,
                user.telegramId,
                user.aboutMe
            );

            return card;
        });
    }

    public override void map() {
        load_content.begin();

        base.map();
    }

    private async void load_content() {
        var users = yield UserManager.instance.get_users();

        foreach (var user in users) {
            list.append(user);
        }
    }
}
