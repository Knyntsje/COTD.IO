namespace Api {

class CupData {
    CupData(const Cup @_cup) {
        switch (_cup.Type) {
            case e_CupType::Day:
                @day = CupDataEntry(_cup);
                break;
            case e_CupType::Night:
                @night = CupDataEntry(_cup);
                break;
            case e_CupType::Morning:
                @morning = CupDataEntry(_cup);
                break;
        }
    }

    CupData(const Json::Value @&in json) {
        if (json["day"].GetType() == Json::Type::Object) {
            @day = CupDataEntry(json["day"]);
        }
        if (json["night"].GetType() == Json::Type::Object) {
            @night = CupDataEntry(json["night"]);
        }
        if (json["morning"].GetType() == Json::Type::Object) {
            @morning = CupDataEntry(json["morning"]);
        }
    }

    CupDataEntry @GetCupDataEntry(const e_CupType &in cupType) const {
        switch (cupType) {
            case e_CupType::Day:
                return day;
            case e_CupType::Night:
                return night;
            case e_CupType::Morning:
                return morning;
        }

        error("[Api::CupData::GetCupDataEntry] Invalid cup type: " + cupType);
        return null;
    }

    CupDataEntry @get_Day() const {
        return day;
    }

    CupDataEntry @get_Night() const {
        return night;
    }

    CupDataEntry @get_Morning() const {
        return morning;
    }

    private CupDataEntry @day;
    private CupDataEntry @night;
    private CupDataEntry @morning;
}

}