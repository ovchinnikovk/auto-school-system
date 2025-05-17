public class UserManager : Object {
    private static UserManager _instance;
    public static UserManager instance {
        get {
            if (_instance == null)
                _instance = new UserManager();

            return _instance;
        }
    }

    private string? token;
    public User? me { get; set; }

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

            return (string)buffer;
        } catch (Error e) {
            critical(@"Error get token: $(e.message)");
        }

        return null;
    }
}
