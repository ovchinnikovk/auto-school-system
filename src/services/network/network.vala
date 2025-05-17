public class Network : GLib.Object {
    public signal void started();
    public signal void finished();
    
    public delegate void ErrorCallback(int code, string reason);
    public delegate void SuccessCallback(InputStream in_stream, Soup.MessageHeaders? response_headers = null) throws Error;
    public delegate void NodeCallback(Json.Node node) throws Error;
    public delegate void ObjectCallback(Json.Object node) throws Error;
    
    public Soup.Session session { get; set; }
    
    public string base_url {get; set;}
    int requests_processing = 0;
    
    public Network.with_base_url(string base_url){
        this.base_url = base_url;
    }
    
    construct {
        session = new Soup.Session.with_options("max-conns", 64, "max-conns-per-host", 64);
        session.request_unqueued.connect(msg => {
            requests_processing--;
            if (requests_processing <= 0)
                finished();
        });
    }
    
    public enum ExtraData {
        RESPONSE_HEADERS
    }
    
    public void queue(
        owned Soup.Message msg,
        GLib.Cancellable? cancellable,
        owned SuccessCallback cb,
        owned ErrorCallback? ecb,
        ExtraData? extra_data = null
    ) {
        requests_processing++;
        started();
        
        debug(@"$(msg.method): $(msg.uri.to_string())");
        
        session.send_async.begin(msg, 0, cancellable, (obj, res) => {
            try {
                var in_stream = session.send_async.end(res);
                
                var status = msg.status_code;
                if (status == Soup.Status.OK) {
                    try {
                        if (cb != null)
                            cb(in_stream, extra_data == ExtraData.RESPONSE_HEADERS ? msg.response_headers : null);
                    } catch (Error e) {
                        warning(@"Error in session: $(e.message)");
                    }
                } else if (status == IOError.CANCELLED) {
                    debug("Message is cancelled. Ignoring callback invocation.");
                } else {
                    if (ecb == null) {
                        critical(@"Request \"$(msg.uri.to_string())\" failed: $status $(msg.reason_phrase)");
                    } else {
                        string error_msg = msg.reason_phrase;
                        
                        try {
                            var parser = Network.get_parser_from_inputstream(in_stream);
                            var root = parse(parser);
                            if (root != null)
                                error_msg = root.get_string_member_with_default("error", msg.reason_phrase);
                        } catch {}
                        
                        ecb((int) status, error_msg);
                    }
                }
            } catch (Error e) {
                if (ecb != null) {
                    ecb(e.code, e.message);
                }
            }
        });
    }
    
    public void on_error(int32 code, string message) {
        warning(message);
    }
    
    public Json.Node? parse_node(Json.Parser parser) {
        return parser.get_root();
    }
    
    public Json.Object? parse(Json.Parser parser) {
        var node = parse_node(parser);
        if (node == null) return null;

        return node.get_object();
    }
    
    public static Json.Parser get_parser_from_inputstream(InputStream in_stream) throws Error {
        var parser = new Json.Parser();
        parser.load_from_stream(in_stream);
        return parser;
    }
    
    public static Json.Array? get_array_mstd (Json.Parser parser) {
        return parser.get_root().get_array();
    }
    
    public static uint get_array_size(Json.Parser parser) {
        return get_array_mstd(parser).get_length();
    }
    
    public static void parse_array(Json.Parser parser, owned NodeCallback cb) throws Error {
        get_array_mstd(parser).foreach_element((array, i, node) => {
            try {
                cb(node);
            } catch (Error e) {
                warning(@"Error parsing array: $(e.message)");
            }
        });
    }
}