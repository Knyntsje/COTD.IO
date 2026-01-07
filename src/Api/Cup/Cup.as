namespace Api {

class Cup {
    Cup(const Json::Value @&in json) {
        id = json["id"];
        liveId = json["liveId"];
        @map = Api::Map(json["map"]);
        type = CupTypeFromAbbreviation(json["type"]);
        numPlayers = json["numPlayers"];
        startTs = Text::ParseInt64(json["startTs"]);
        endTs = Text::ParseInt64(json["endTs"]);
    }

    int get_Id() const {
        return id;
    }

    string get_LiveId() const {
        return liveId;
    }

    Api::Map @get_Map() const {
        return map;
    }

    e_CupType get_Type() const {
        return type;
    }

    int get_NumPlayers() const {
        return numPlayers;
    }

    int64 get_StartTs() const {
        return startTs;
    }

    int64 get_EndTs() const {
        return endTs;
    }
  
    private int id;
    private string liveId;
    private Api::Map @map;
    private e_CupType type;
    private int numPlayers;
    private int64 startTs;
    private int64 endTs;
}

}