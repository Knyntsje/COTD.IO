namespace Api {

class TopPlayer {
    TopPlayer(const Json::Value @&in json) {
        @player = Api::Player(json["player"]);
        position = json["position"];
        quantity = json["quantity"];
    }

    Api::Player @get_Player() const {
        return player;
    }

    int get_Position() const {
        return position;
    }

    int get_Quantity() const {
        return quantity;
    }

    private Api::Player @player;
    private int position;
    private int quantity;
}

}