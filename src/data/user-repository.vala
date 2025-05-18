public class UserRepository : Object {
    private static UserRepository _instance;
    public static UserRepository instance {
        get {
            if (_instance == null)
                _instance = new UserRepository();

            return _instance;
        }
    }

    private User? _user;
    public User? user {
        get { return _user; }
        set {
            _user = value;
            user_loaded(value);
        }
    }
    public User? me { get; set; }
    public Gee.ArrayList<User> items { get; set; }

    public signal void user_loaded(User user);
} 
