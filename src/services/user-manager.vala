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
    public signal void user_loaded();

    public async void get_me(string email, string password) {
        try {
            var token = yield get_token(email, password);

            if (token == null)
                return;

            var req = new Request.GET("/api/me")
            .with_token(token);

            yield req.await();

            var node = Network
            .get_parser_from_inputstream(req.response_body)
            .get_root();

            UserRepository.instance.me = (User)Json.gobject_deserialize (typeof(User), node);
            user_loaded();
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
}
