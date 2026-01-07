namespace Api {

class PlayerCup : Cup {
    PlayerCup(const Json::Value @&in json) {
        super(json);
        position = Api::Position(json["position"]);
    }

    const Api::Position get_Position() const {
        return position;
    }

    private Api::Position position;
}

}