public class AsyncImage : Gtk.Widget {
    private Gtk.Picture picture;
    private string? _uri = null;
    public string? uri { get { return _uri; }
        set {
            _uri = value;
            load_uri.begin(value);
        }
    }
    private Bytes _bytes;
    public Bytes bytes {
        get { return _bytes; }
        set {
            _bytes = value;
            load_form_data.begin(value);
        }
    }
    public string alternative_text {
        get { return picture.alternative_text; }
        set { picture.alternative_text = value; }
    }
    public bool can_shrink {
        get { return picture.can_shrink; }
        set { picture.can_shrink = value; }
    }
    public Gtk.ContentFit content_fit {
        get { return picture.content_fit; }
        set { picture.content_fit = value; }
    }
    public Gdk.Paintable paintable {
        get { return picture.paintable; }
        set { picture.paintable = value; }
    }
    private int _texture_height;
    public int texture_height {
        get { return _texture_height; }
    }
    private int _texture_width;
    public int texture_width {
        get { return _texture_width; }
    }

    construct {
        picture = new Gtk.Picture();
        picture.set_parent(this);
    }

    public AsyncImage() {}

    public async void load_uri(string uri) {
        Gdk.Texture? texture = null;

        new Thread<void>("texture-thread", () => {
            try {
                texture = Gdk.Texture.from_file(File.new_for_path(uri));
                _texture_height = texture.get_height();
                _texture_width = texture.get_width();
            } catch (Error err) {
                warning("Error while loading texture from uri: %s", err.message);
            } finally {
                Idle.add(load_uri.callback);
            }
        });

        yield;
        paintable = texture;
    }

    public async void load_form_data(Bytes bytes) {
        Gdk.Texture? texture = null;

        new Thread<void>("texture-thread", () => {
            try {
                texture = Gdk.Texture.from_bytes(bytes);
                _texture_height = texture.get_height();
                _texture_width = texture.get_width();
            } catch (Error err) {
                warning("Error while loading texture from uri: %s", err.message);
            } finally {
                Idle.add(load_form_data.callback);
            }
        });

        yield;
        paintable = texture;
    }

    public override void size_allocate(int width, int height, int baseline) {
        picture.allocate(width, height, -1, null);
    }

    public override void dispose() {
        picture.unparent();
        base.dispose();
    }
}
