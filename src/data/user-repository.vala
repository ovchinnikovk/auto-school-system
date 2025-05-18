public class UserRepository : Object {
    private static UserRepository _instance;
    public static UserRepository instance {
        get {
            if (_instance == null)
                _instance = new UserRepository();

            return _instance;
        }
    }

    public User? me { get; set; }
    public Gee.ArrayList<User?> items { get; set; default = new Gee.ArrayList<User?>(); }
} 
