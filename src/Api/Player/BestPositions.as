namespace Api {

class BestPositions {
    BestPositions(const Json::Value @&in json) {
        if (json is null || json.GetType() != Json::Type::Array) {
            return;
        }

        if (json.Length > 0) {
            minPosition = json[0]["position"];
            maxPosition = json[json.Length - 1]["position"];
        }

        int lastPosition = 0;
        for (uint i = 0; i < json.Length; i++) {
            const Json::Value @item = json[i];

            const int position = item["position"];
            for (int j = lastPosition + 1; j < position; j++) {
                amounts.InsertLast(0.f);
            }

            lastPosition = position;
            amounts.InsertLast(item["amount"]);
        }
    }

    int get_MinPosition() const {
        return minPosition;
    }

    int get_MaxPosition() const {
        return maxPosition;
    }

    array<float> get_Amounts() const {
        return amounts;
    }

    int minPosition = 0;
    int maxPosition = 0;

    private array<float> amounts;
}

}