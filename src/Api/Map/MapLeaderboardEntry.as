namespace Api {

class MapLeaderboardEntry {
    MapLeaderboardEntry(const Json::Value @&in json) {
        mapUid = json["mapUid"];
        position = json["position"];
        @player = Api::Player(json["player"]);
        zoneId = json["zoneId"];
        score = json["score"];
        mapRecordId = json["mapRecordId"];
        medal = Text::ParseInt(json["medal"]);
        when = json["when"];
    }

    string get_MapUid() const {
        return mapUid;
    }

    int get_Position() const {
        return position;
    }

    Api::Player @get_Player() const {
        return player;
    }

    string get_ZoneId() const {
        return zoneId;
    }

    int64 get_Score() const {
        return score;
    }

    string get_MapRecordId() const {
        return mapRecordId;
    }

    int get_Medal() const {
        return medal;
    }

    string get_When() const {
        return when;
    }

    private string mapUid;
    private int position;
    private Api::Player @player;
    private string zoneId;
    private int64 score;
    private string mapRecordId;
    private int medal;
    private string when;
}

}