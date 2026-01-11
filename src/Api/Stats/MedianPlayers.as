namespace Api {

class MedianPlayers {
    MedianPlayers(const Json::Value @&in json) {
        if (json is null || json.GetType() != Json::Type::Array) {
            return;
        }
        
        for (uint i = 0; i < json.Length; i++) {
            const Json::Value @item = json[i];
            const e_CupType cupType = CupTypeFromAbbreviation(item["type"]);

            const float avgPlayersThisYear = item["avg_players_this_year"].GetType() == Json::Type::Null ? 0.f : item["avg_players_this_year"];
            const float avgPlayersLastYear = item["avg_players_last_year"].GetType() == Json::Type::Null ? 0.f : item["avg_players_last_year"];
            switch (cupType) {
                case e_CupType::Day:
                    cotdThisYear.InsertLast(avgPlayersThisYear);
                    cotdLastYear.InsertLast(avgPlayersLastYear);
                    containsCotd = true;
                    break;
                case e_CupType::Morning:
                    cotmThisYear.InsertLast(avgPlayersThisYear);
                    cotmLastYear.InsertLast(avgPlayersLastYear);
                    containsCotm = true;
                    break;
                case e_CupType::Night:
                    cotnThisYear.InsertLast(avgPlayersThisYear);
                    cotnLastYear.InsertLast(avgPlayersLastYear);
                    containsCotn = true;
                    break;
            }
        }
    }

    bool get_ContainsCotd() const {
        return containsCotd;
    }

    bool get_ContainsCotm() const {
        return containsCotm;
    }

    bool get_ContainsCotn() const {
        return containsCotn;
    }

    array<float> get_CotdThisYear() const {
        return cotdThisYear;
    }

    array<float> get_CotdLastYear() const {
        return cotdLastYear;
    }

    array<float> get_CotmThisYear() const {
        return cotmThisYear;
    }

    array<float> get_CotmLastYear() const {
        return cotmLastYear;
    }

    array<float> get_CotnThisYear() const {
        return cotnThisYear;
    }

    array<float> get_CotnLastYear() const {
        return cotnLastYear;
    }

    bool containsCotd = false;
    bool containsCotm = false;
    bool containsCotn = false;
    
    private array<float> cotdThisYear;
    private array<float> cotdLastYear;
    private array<float> cotmThisYear;
    private array<float> cotmLastYear;
    private array<float> cotnThisYear;
    private array<float> cotnLastYear;
}

}