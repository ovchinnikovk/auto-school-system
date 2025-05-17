public Gee.ArrayList<T> try_deserialize_array<T>(Type element_type, Json.Node property_node){
    var res = new Gee.ArrayList<T>();
    foreach (var item in property_node
        .get_array()
        .get_elements()){
        var obj = (T) Json.gobject_deserialize(element_type, item);
        res.add(obj);
    }
    return res;
}

public Gee.ArrayList<int> try_deserialize_int_array(Json.Node property_node){
    var res = new Gee.ArrayList<int>();
    foreach (var item in property_node
        .get_array()
        .get_elements()){
        var obj = (int)item.get_int();
        res.add(obj);
    }
    return res;
}
