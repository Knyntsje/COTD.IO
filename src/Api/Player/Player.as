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
        if (!avatarLoaded) {
            startnew(CoroutineFunc(LoadAvatar));
        }
        return @avatar;
    }

    private void LoadAvatar() {
        avatarLoaded = true;
        
        Net::HttpRequest @request = Net::HttpRequest("https://wsrv.nl/?url=https://avatars.ubisoft.com/" + uplayUid + "/default_146_146.png?w=18&h=18&fit=cover&mask=circle");
        await(request.Start());

        if (request.ResponseCode() / 100 != 2 || request.Buffer().GetSize() <= 0) {
            warn("[Api::Player::LoadAvatar] Avatar download request failed. Code: " + request.ResponseCode() + " Error: " + request.Error());
            return;
	    }

        @avatar = UI::LoadTexture(request.Buffer());
    }

    private string accountId;
    private string uplayUid;
    private string zoneId;
    private string name;
    private string tag;

    private UI::Texture @avatar = null;
    private bool avatarLoaded = false;
}

}