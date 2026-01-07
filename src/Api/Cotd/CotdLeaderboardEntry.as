namespace Api {

class CotdLeaderboardEntry {
    CotdLeaderboardEntry(const Json::Value @&in json) {
        position = Api::Position(json["position"]);
        @player = Api::Player(json["player"]);
    }

    const Api::Position get_Position() const {
        return position;
    }

    Api::Player @get_Player() const {
        return player;
    }

    private Api::Position position;
    private Api::Player @player;
}

}