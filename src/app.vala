public static Network network;
public static Settings settings;

public class AutoSchule : Adw.Application {
    public MainWindow main_window;

    private static AutoSchule _instance;
    public static AutoSchule instance {
        get {
            if (_instance == null)
                _instance = new AutoSchule();

            return _instance;
        }
    }

    construct {
        application_id = "org.gtk.AutoSchoolSystem";
        flags = ApplicationFlags.DEFAULT_FLAGS;
        settings = new Settings(application_id);
        message(settings.get_string("host"));
        network = new Network.with_base_url(settings.get_string("host"));
    }

    public override void activate() {
        if (main_window != null) {
            main_window.present();
            return;
        }
        MainWindow.ensure_types();

        main_window = new MainWindow(this);

        main_window.present();
    }

    public static int main(string[] args) {
        var app = AutoSchule.instance;
        return app.run(args);
    }
}
