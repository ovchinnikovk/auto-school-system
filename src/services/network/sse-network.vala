public class SSEResponse{
    public string event{get;set;}
    public Json.Parser data{ get; set;}
}

public class SSENetwork : GLib.Object {
    public signal void received(SSEResponse response);
    
    public delegate void ErrorCallback(int code, string reason);
    
    private Soup.Session _session;
    private string _url;
    private bool _connected;
    public SSENetwork(string url){
        _url = url;
        _session = new Soup.Session.with_options(
            "max-conns", 64, 
            "max-conns-per-host", 64,
        "timeout",0);
        new Thread<void>("sse_thread",start);
    }
    
    public void start() {
        var msg = new Soup.Message("GET",_url);
        _connected = true;
        debug(@"$(msg.method): $(msg.uri.to_string())");
        try {
            var in_stream = (PollableInputStream)_session.send(msg);
            
            var status = msg.status_code;
            
            if(status != Soup.Status.OK){
                critical(@"SSE session \"$(msg.uri.to_string())\" failed: $status $(msg.reason_phrase)");
            }
            else if(status == IOError.CANCELLED){
                debug("Message is cancelled. Ignoring callback invocation.");
            }
            else{
                var source = in_stream.create_source();
                source.set_callback((s)=>{
                    receive((PollableInputStream)s);
                    return true;
                });
                source.attach(null);
                receive(in_stream);
            }
        } catch (Error e) {
            critical(@"SSE session failed: $(e.message)");
        }
        finally{
            _connected = false;
        }
        
    }
    
    private void receive(PollableInputStream in_stream){
        
        try {
            var buffer = new uint8[1024];
            in_stream.read(buffer);
            var result = (string)buffer;
            var regex = new Regex("""event:\s*(.+)\s*data:\s*(\{.+?\})\s*""");
            GLib.MatchInfo match_info;
            regex.match(result, 0, out match_info);
            message(@"sse_match_info: $(match_info.get_string())");
            var ev = match_info.fetch(1);
            var d =  match_info.fetch(2);
            if (ev == "Clear")  {
                message(@"sse_event: $(ev)");
                return;
            }
            if (ev == null || ev == "") {
                message("sse_event: null");
                return;
            }
            message(@"sse_receive_event: $(ev) - sse_receive_data: $(d)");
            var parser = new Json.Parser();
            parser.load_from_data(d,d.length);
            received(new SSEResponse()
                {
                    event = ev,
                    data = parser
                });
        } catch (Error e) {
            critical(@"Error in session: $(e.message) $(e.domain)");
        }
    }
}
