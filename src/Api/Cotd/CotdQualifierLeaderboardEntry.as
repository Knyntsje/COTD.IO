namespace Api {

class CotdQualifierLeaderboardEntry : CotdLeaderboardEntry {
    CotdQualifierLeaderboardEntry(const Json::Value @&in json) {
        super(json);
        score = json["score"];
    }

    int64 get_Score() const {
        return score;
    }

    private int64 score;
}

}