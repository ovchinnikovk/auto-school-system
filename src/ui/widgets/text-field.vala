[GtkTemplate (ui = "/org/gtk/AutoSchoolSystem/text-field.ui")]
public class TextField : Gtk.Box {
    private bool _checked;
    private string _input = "";

    public bool only_numbers { get; set; }
    public string placeholder { get; set; }
    public string input { get { return _input; }
        set {
            _input = value;
            text.label = input;
        }
    }
    public bool checked { get { return _checked; }
        set {
            _checked = value;
            if (value) {
                css_classes = {};
                set_state_flags(Gtk.StateFlags.SELECTED, false);
                text.label = input;
                text.use_markup = false;
            } else {
                unset_state_flags(Gtk.StateFlags.SELECTED);
                if (input == "") {
                    text.label = placeholder;
                    text.use_markup = true;
                }
            }
        }
    }

    [GtkChild]
    private unowned Gtk.Label text;

    static construct {
        set_css_name("text-field");
    }

    public override void map() {
        base.map();

        input = "";
        css_classes = {};
        text.label = placeholder;
        text.use_markup = true;
    }

    [GtkCallback]
    private new void focus() {

    }

    public void unfocus() {
        checked = false;
    }
}
