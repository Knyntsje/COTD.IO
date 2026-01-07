namespace Api {

class Totd {
    Totd(const Cup @_cup) {
        dateTs = _cup.StartTs;
        @map = _cup.Map;
        startTs = _cup.StartTs;
        endTs = _cup.EndTs;
        @cupData = Api::CupData(_cup);
    }

    Totd(const Json::Value @&in json) {
        dateTs = Time::ParseFormatString("%Y-%m-%dT%H:%M:%S", json["date"]);
        @map = Api::Map(json["map"]);
        startTs = Text::ParseInt(json["startTs"]);
        endTs = Text::ParseInt(json["endTs"]);

        if (json["cupData"] !is null) {
            @cupData = Api::CupData(json["cupData"]);
        }
    }

    int64 get_DateTs() const {
        return dateTs;
    }

    Api::Map @get_Map() const {
        return map;
    }

    int64 get_StartTs() const {
        return startTs;
    }

    int64 get_EndTs() const {
        return endTs;
    }

    Api::CupData @get_CupData() const {
        return cupData;
    }

    private int64 dateTs;
    private Api::Map @map;
    private int64 startTs;
    private int64 endTs;
    private Api::CupData @cupData;
}

}