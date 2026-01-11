namespace Api {

class MedianPositions {
    MedianPositions(const Json::Value @&in json) {
        if (json is null || json.GetType() != Json::Type::Array) {
            return;
        }
        
        for (uint i = 0; i < json.Length; i++) {
            const Json::Value @item = json[i];
            thisYear.InsertLast(item["median_position_this_year"].GetType() == Json::Type::Null ? 0.f : item["median_position_this_year"]);
            lastYear.InsertLast(item["median_position_last_year"].GetType() == Json::Type::Null ? 0.f : item["median_position_last_year"]);
        }
    }

    array<float> get_ThisYear() const {
        return thisYear;
    }

    array<float> get_LastYear() const {
        return lastYear;
    }
    
    private array<float> thisYear;
    private array<float> lastYear;
}

}