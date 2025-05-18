public class Request : GLib.Object {
	private Soup.Message _msg;
	public Soup.Message msg {
		get {
			return _msg;
		}
		set {
			if (cancellable != null && !cancellable.is_cancelled()) cancellable.cancel();
			_msg = value;
			cancellable = new Cancellable();
		}
	}
	public string url { set; get; }
	public Soup.MessagePriority priority { set; get; }
	
	private bool use_auth = false;
	private string _method;
	public string method {
		set {
			_method = value;
			if (msg != null)
				msg.method = value;
		}

		get {
			return msg == null ? _method : msg.method;
		}
	}
	public InputStream response_body { get; set; }
	Network.SuccessCallback? cb;
	Network.ErrorCallback? error_cb;
	Gee.HashMap<string, string>? pars;
	Soup.Multipart? form_data;
	public GLib.Cancellable cancellable;
    string? token;

	Network.ExtraData? extra_data;
	weak Gtk.Widget? ctx;
	bool has_ctx = false;

	public Request.GET(string url) {
		this.url = url;
		method = "GET";
		msg = new Soup.Message(method, url);
	}
	public Request.POST(string url) {
		this.url = url;
		method = "POST";
		msg = new Soup.Message(method, url);
	}
	public Request.PUT(string url) {
		this.url = url;
		method = "PUT";
		msg = new Soup.Message(method, url);
	}
	public Request.DELETE(string url) {
		this.url = url;
		method = "DELETE";
		msg = new Soup.Message(method, url);
	}
	public Request.PATCH(string url) {
		this.url = url;
		method = "PATCH";
		msg = new Soup.Message(method, url);
	}

	private string? content_type = null;
	private Bytes? body_bytes = null;
	public void set_request_body_from_bytes(string? t_content_type, Bytes? t_bytes) {
		content_type = t_content_type;
		body_bytes = t_bytes;
	}

	public Request then(owned Network.SuccessCallback cb) {
		this.cb = (owned) cb;
		return this;
	}

	public Request then_parse_array(owned Network.NodeCallback _cb) {
		this.cb = (in_stream) => {
			var parser = Network.get_parser_from_inputstream(in_stream);
			Network.parse_array(parser, (owned) _cb);
		};
		return this;
	}

	public Request with_extra_data(Network.ExtraData xtra_data) {
		this.extra_data = xtra_data;
		return this;
	}

	public Request with_ctx(Gtk.Widget ctx) {
		this.has_ctx = true;
		this.ctx = ctx;
		this.ctx.destroy.connect(() => {
			this.cancellable.cancel();
			this.ctx = null;
		});
		return this;
	}

	public Request on_error(owned Network.ErrorCallback cb) {
		this.error_cb = (owned) cb;
		return this;
	}

	public Request with_auth() {
		use_auth = true;
		return this;
	}

	public Request with_token(string token) {
        use_auth = true;
        this.token = token;
        return this;
    }

	public Request with_param (string name, string val) {
		if (pars == null)
			pars = new Gee.HashMap<string, string> ();
		pars[name] = val;
		return this;
	}

	public Request with_form_data (string name, string val) {
		if (form_data == null)
			form_data = new Soup.Multipart (Soup.FORM_MIME_TYPE_MULTIPART);
		form_data.append_form_string (name, val);
		return this;
	}

	public Request with_form_data_file (string name, string mime, Bytes buffer) {
		if (form_data == null)
			form_data = new Soup.Multipart (Soup.FORM_MIME_TYPE_MULTIPART);
		form_data.append_form_file (name, mime.replace ("/", "."), mime, buffer);
		return this;
	}

	public Request body (string? t_content_type, Bytes? t_bytes) {
		content_type = t_content_type;
		body_bytes = t_bytes;
		return this;
	}

	public Request body_json (Json.Builder t_builder) {
		var generator = new Json.Generator ();
		generator.set_root (t_builder.get_root ());
		return body ("application/json", new Bytes.take (generator.to_data (null).data));
	}

	private bool cache = true;
	public Request disable_cache() {
		cache = false;
		return this;
	}

	public Request exec() {
		var parameters = "";
		if (pars != null) {
			if ("?" in url)
				parameters = "&";
			else
				parameters = "?";

			var parameters_counter = 0;
			pars.@foreach (entry => {
				parameters_counter++;
				var key = (string) entry.key;
				var val = Uri.escape_string ((string) entry.value);
				parameters += @"$key=$val";

				if (parameters_counter < pars.size)
					parameters += "&";

				return true;
			});
		}


		if (!("://" in url))
			url = network.base_url + url;

		if (msg == null)
			msg = new Soup.Message (method, url);

		if (form_data != null) {
			var t_method = msg.method;
			msg = new Soup.Message.from_multipart (url + parameters, form_data);
			msg.method = t_method;
		} else {
			Uri t_uri;
			try {
				t_uri = Uri.parse(url + parameters, UriFlags.ENCODED_PATH | UriFlags.ENCODED_QUERY);
			} catch (UriError e) {
				warning(e.message);
				return this;
			}
			msg.uri = t_uri;
		}

		if (use_auth) {
			msg.request_headers.remove("Authorization");
			msg.request_headers.append("Authorization", @"Bearer $(token)");
		}

		if (!cache) msg.disable_feature(typeof(Soup.Cache));
		msg.priority = priority;
        
		if (content_type != null && body_bytes != null)
			msg.set_request_body_from_bytes(content_type, body_bytes);
		
		network.queue(msg, this.cancellable, (owned) cb, (owned) error_cb, extra_data);
		return this;
	}

	public async Request await() throws IOError, NetworkError {
		string? error = null;
        int? err_code = null;
		this.error_cb = (code, reason) => {
            err_code = code;
			error = reason;
			await.callback();
		};
		this.cb = (in_stream) => {
			this.response_body = in_stream;
			await.callback();
		};
		this.exec();
		yield;

		if (error != null && err_code/100!=2) {
            if (err_code >= 400) {
                throw new NetworkError.CLIENT(error);           
            } else if (err_code >= 500) {
                throw new NetworkError.SERVER(error);
            } else {
                throw new IOError.FAILED(error);
            }
        }
		else
			return this;
	}

	public static string array2string (Gee.ArrayList<string> array, string key) {
		var result = "";
		array.@foreach (i => {
			result += @"$key[]=$i";
			if (array.index_of (i) + 1 != array.size)
				result += "&";
			return true;
		});
		return result;
	}
	
}
