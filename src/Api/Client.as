namespace Api {

class Client {
    Client() {
        if (Meta::ExecutingPlugin().Version == "dev") {
            baseUrl = "http://localhost:5173/api";
        }
    }

    /// FYI: AngelScript is optimizing the out parameter away if we also use it as input offset, so we need to use separate
    /// parameters for in and out offsets. I think it's due to having to use &out instead of &inout (which it should technically be)
    /// and because it then doesn't consider this as an input, it doesn't see any other references to it and thus it optimizes it away.
    /// AngelScript doesn't seem to support &inout for primitive types due to them not supporting handles (which is bs).
    /// Thanks for listening to my TED talk. AAAAAAAAAAAAAAAAAAAA
    array<Totd@> GetTotds(const string &in search, const int year, const int month, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/totds/" + offset + "?search=" + search + "&year=" + year + "&month=" + month);
        if (json.GetType() != Json::Type::Object) {
            return array<Totd@>();
        }
        
        newOffset = json["offset"];

        array<Totd@> totds = array<Totd@>();

        const Json::Value @totdsJson = json["totds"];
        for (uint i = 0; i < totdsJson.Length; ++i) {
            totds.InsertLast(Totd(totdsJson[i]));
        }
        return totds;
    }

    Player @GetPlayer(const string &in accountId) const {
        array<string> accountIds = array<string>();
        accountIds.InsertLast(accountId);

        int offset = 0;
        const array<Player@> players = GetPlayers("", accountIds, offset, offset);
        return players.Length == 1 ? players[0] : null;
    }

    array<Player@> GetPlayers(const string &in search, const array<string> &in accountIds, const int offset, int &out newOffset) const {
        string accountIdsString = "";
        foreach (const string accountId : accountIds) {
            accountIdsString = AppendString(accountIdsString, accountId, ",");
        }

        const Json::Value @json = GetJson(baseUrl + "/players/" + offset + "?search=" + search + "&accountIds=" + accountIdsString);
        if (json.GetType() != Json::Type::Object) {
            return array<Player@>();
        }
        
        newOffset = json["offset"];

        array<Player@> players = array<Player@>();

        const Json::Value @playersJson = json["players"];
        for (uint i = 0; i < playersJson.Length; ++i) {
            players.InsertLast(Player(playersJson[i]));
        }
        return players;
    }

    array<MapLeaderboardEntry@> GetMapLeaderboard(const string &in mapUid, const string &in search, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/map/" + mapUid + "/leaderboard/" + offset + "?search=" + search);
        if (json.GetType() != Json::Type::Object) {
            return array<MapLeaderboardEntry@>();
        }
        
        newOffset = json["offset"];

        array<MapLeaderboardEntry@> leaderboard = array<MapLeaderboardEntry@>();

        const Json::Value @leaderboardJson = json["leaderboard"];
        for (uint i = 0; i < leaderboardJson.Length; ++i) {
            leaderboard.InsertLast(MapLeaderboardEntry(leaderboardJson[i]));
        }
        return leaderboard;
    }

    array<CotdLeaderboardEntry@> GetCotdLeaderboard(const int cotdId, const string &in search, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/cotd/" + cotdId + "/leaderboard/" + offset + "?search=" + search);
        if (json.GetType() != Json::Type::Object) {
            return array<CotdLeaderboardEntry@>();
        }
        
        newOffset = json["offset"];

        array<CotdLeaderboardEntry@> leaderboard = array<CotdLeaderboardEntry@>();

        const Json::Value @leaderboardJson = json["leaderboard"];
        for (uint i = 0; i < leaderboardJson.Length; ++i) {
            leaderboard.InsertLast(CotdLeaderboardEntry(leaderboardJson[i]));
        }
        return leaderboard;
    }

    array<CotdQualifierLeaderboardEntry@> GetCotdQualifierLeaderboard(const int cotdId, const string &in search, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/cotd/" + cotdId + "/qualifier/" + offset + "?search=" + search);
        if (json.GetType() != Json::Type::Object) {
            return array<CotdQualifierLeaderboardEntry@>();
        }
        
        newOffset = json["offset"];

        array<CotdQualifierLeaderboardEntry@> leaderboard = array<CotdQualifierLeaderboardEntry@>();

        const Json::Value @leaderboardJson = json["leaderboard"];
        for (uint i = 0; i < leaderboardJson.Length; ++i) {
            leaderboard.InsertLast(CotdQualifierLeaderboardEntry(leaderboardJson[i]));
        }
        return leaderboard;
    }

    array<PlayerCup@> GetPlayerCups(const string &in accountId, const array<e_CupType> &in cupTypes, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/players/" + accountId + "/cotds/" + offset + "?types=" + FormatCupTypes(cupTypes));
        if (json.GetType() != Json::Type::Object) {
            return array<PlayerCup@>();
        }
        
        newOffset = json["offset"];
        
        array<PlayerCup@> cups = array<PlayerCup@>();

        const Json::Value @cupsJson = json["cotds"];
        for (uint i = 0; i < cupsJson.Length; ++i) {
            cups.InsertLast(PlayerCup(cupsJson[i]));
        }
        return cups;
    }

    Json::Value @GetPlayerCupNumberStats(const string &in accountId, const array<e_CupType> &in cupTypes) const {
        return GetJson(baseUrl + "/players/" + accountId + "/cotds/stats/number?types=" + FormatCupTypes(cupTypes));
    }

    array<PlayerTotd@> GetPlayerTotds(const string &in accountId, const int offset, int &out newOffset) const {
        const Json::Value @json = GetJson(baseUrl + "/players/" + accountId + "/totds/" + offset);
        if (json.GetType() != Json::Type::Object) {
            return array<PlayerTotd@>();
        }

        newOffset = json["offset"];

        array<PlayerTotd@> totds = array<PlayerTotd@>();

        const Json::Value @totdsJson = json["totds"];
        for (uint i = 0; i < totdsJson.Length; ++i) {
            totds.InsertLast(PlayerTotd(totdsJson[i]));
        }
        return totds;
    }

    Json::Value @GetPlayerTotdNumberStats(const string &in accountId) const {
        return GetJson(baseUrl + "/players/" + accountId + "/totds/stats/number");
    }

    private Json::Value @GetJson(const string &in url) const {
        Net::HttpRequest@ request = Net::HttpRequest(url);
        await(request.Start());

        if (request.ResponseCode() / 100 != 2) {
            error("[Client::GetJson] Request failed. URL: " + url + " Code: " + request.ResponseCode() + " Error: " + request.Error());
            return Json::Value();
        }

        return request.Json();
    }

    private string FormatCupTypes(const array<e_CupType> &in cupTypes) const {
        string types = "";
        foreach (const e_CupType cupType : cupTypes) {
            types = AppendString(types, CupTypeToString(cupType), ",");
        }
        return types;
    }
    
    private string baseUrl = "https://cotd.io/api";
}
Client client;

}