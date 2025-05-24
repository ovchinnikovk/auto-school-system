public class UserManager : Object {
    private static UserManager _instance;
    public static UserManager instance {
        get {
            if (_instance == null)
                _instance = new UserManager();

            return _instance;
        }
    }

    public signal void error_authentication(string error);

    public async Gee.ArrayList<User>? get_users() {
        try {
            var req = new Request.GET("/api/users");

            yield req.await();

            var node = Network
            .get_parser_from_inputstream(req.response_body)
            .get_root();

            return yield try_deserialize_user_array(node);
        } catch (Error e) {
            critical(@"Error get all users: $(e.message)");
        }

        return null;
    }

    public async void get_me(string email, string password) {
        try {
            var token = yield get_token(email, password);

            if (token == null)
                return;

            bearer_token = token;
            var req = new Request.GET("/api/me")
            .with_auth();

            yield req.await();

            var node = Network
            .get_parser_from_inputstream(req.response_body)
            .get_root();
            users.me = (User)Json.gobject_deserialize (typeof(User), node);
            users.user = yield get_user_by_id(users.me.id);
        } catch (Error e) {
            critical(@"Error get me: $(e.message)");
        }
    }

    public async string? get_token(string email, string password) {
        var builder = new Json.Builder();
        builder.begin_object();
        builder.set_member_name("email");
        builder.add_string_value(email);
        builder.set_member_name("password");
        builder.add_string_value(password);
        builder.end_object();

        try {
            var req = new Request.POST("/api/authentication_token")
            .body_json(builder);

            yield req.await();

            var buffer = new uint8[1024];
            req.response_body.read(buffer);
            message(@"user_manager_get_token response body: $((string)buffer)");

            var regex = /token"\s*:\s*"([a-zA-Z0-9_\-]+\.[a-zA-Z0-9_\-]+\.[a-zA-Z0-9_\-]*)/;
            MatchInfo? info;
            regex.match((string)buffer, RegexMatchFlags.DEFAULT, out info);
            var token = info.fetch(1);

            return token;
        } catch (Error e) {
            critical(@"Error get token: $(e.message)");

            handle_error_token(e.message);
        }

        return null;
    }

    private void handle_error_token(string token) {
        switch (token) {
            case "Unauthorized":
                error_authentication("Пользователь не найден");
                break;
            case "Bad Request":
                error_authentication("Заполните все поля");
                break;
        }
    }

    public async User? get_user_by_id(int id) {
        try {
            var req = new Request.GET(@"/api/users/$(id)")
            .with_auth();
            yield req.await();

            var root = Network
            .get_parser_from_inputstream(req.response_body)
            .get_root()
            .get_object();

            var user = yield try_deserialize_user(root);

            return user;
        } catch (Error e) {
            critical(@"Error get user: $(e.message)");
        }
        return null;
    }

    public async void add_user(User user) {
        var builder = new Json.Builder();
        builder.begin_object();
        builder.set_member_name("name");
        builder.add_string_value(user.name);
        builder.set_member_name("surname");
        builder.add_string_value(user.surname);
        builder.set_member_name("patronym");
        builder.add_string_value(user.patronym);
        builder.set_member_name("phone");
        builder.add_string_value(user.phone);
        builder.set_member_name("email");
        builder.add_string_value(user.email);
        builder.set_member_name("telegramId");
        builder.add_string_value(user.telegramId);
        builder.set_member_name("roles");
        builder.begin_array();
        foreach (var role in user.roles)
            builder.add_string_value(role);
        builder.end_array();
        builder.end_object();

        try {
            var req = new Request.POST("/api/users")
            .body_json(builder)
            .with_auth();

            yield req.await();

            var buffer = new uint8[1024];
            req.response_body.read(buffer);
            message(@"add_user response body: $((string)buffer)");
        } catch (Error e) {
            critical(@"Error can`t add user: $(e.message)");
        }
    }

    public async void delete_user(int id) {
        try {
            var req = new Request.DELETE(@"/api/users/$(id)")
            .with_auth();
            yield req.await();

            var buffer = new uint8[1024];
            req.response_body.read(buffer);
            message(@"delete_user response body: $((string)buffer)");
        } catch (Error e) {
            critical(@"Can`t delete user: $(e.message)");
        }
    }
}
