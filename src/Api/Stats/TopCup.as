namespace Api {

class TopCup : Api::Cup {
    TopCup(const Json::Value @&in json) {
        super(json);
        position = json["position"];
    }
    
    int get_Position() const {
        return position;
    }

    private int position;
}

}