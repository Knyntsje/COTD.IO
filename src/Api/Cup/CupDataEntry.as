namespace Api {

class CupDataEntry {
    CupDataEntry(const Cup @_cup) {
        id = _cup.Id;
        numPlayers = _cup.NumPlayers;
    }

    CupDataEntry(const Json::Value @&in json) {
        id = json["id"];
        numPlayers = json["numPlayers"];
    }

    int get_Id() const {
        return id;
    }

    int get_NumPlayers() const {
        return numPlayers;
    }

    private int id;
    private int numPlayers;
}

}