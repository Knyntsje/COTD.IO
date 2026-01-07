namespace Api {

class Map {
    Map(const Json::Value @&in json) {
        id = json["id"];
        uid = json["uid"];
        name = json["name"];
        @author = Player(json.Get("author"));
        bronzeScore = json["bronzeScore"];
        silverScore = json["silverScore"];
        goldScore = json["goldScore"];
        authorScore = json["authorScore"];
    }

    string GetDisplayName() const {
        return Text::OpenplanetFormatCodes(name);
    }

    string get_Id() const {
        return id;
    }

    string get_Uid() const {
        return uid;
    }

    string get_Name() const {
        return name;
    }

    Player @get_Author() const {
        return author;
    }

    int64 get_BronzeScore() const {
        return bronzeScore;
    }

    int64 get_SilverScore() const {
        return silverScore;
    }

    int64 get_GoldScore() const {
        return goldScore;
    }

    int64 get_AuthorScore() const {
        return authorScore;
    }

    private string id;
    private string uid;
    private string name;
    private Player @author;
    private int64 bronzeScore;
    private int64 silverScore;
    private int64 goldScore;
    private int64 authorScore;
}

}