namespace Api {

class Player {
    Player(const string &in _accountId) {
        accountId = _accountId;
    }

    Player(const Json::Value @&in json) {
        accountId = json["accountId"];
        uplayUid = json["uplayUid"];
        zoneId = json["zoneId"];
        name = json["name"];
        tag = json["tag"];
    }

    string GetDisplayName() const {
        if (tag.Length > 0) {
            return "[" + Text::OpenplanetFormatCodes(tag) + "\\$fff] " + name;
        }
        return name;
    }

    string get_AccountId() const {
        return accountId;
    }

    string get_UplayUid() const {
        return uplayUid;
    }

    string get_ZoneId() const {
        return zoneId;
    }

    string get_Name() const {
        return name;
    }

    string get_Tag() const {
        return tag;
    }

    UI::Texture @get_Avatar() const {
        return AvatarCache::Get(uplayUid);
    }

    private string accountId;
    private string uplayUid;
    private string zoneId;
    private string name;
    private string tag;
}

}