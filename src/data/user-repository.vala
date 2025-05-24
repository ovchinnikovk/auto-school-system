public class UserRepository : Object {
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
