namespace Api {

class DivDistribution {
    DivDistribution(const Json::Value @&in json) {
        if (json is null || json.GetType() != Json::Type::Array) {
            return;
        }

        for (uint i = 0; i < json.Length; i++) {
            const Json::Value @item = json[i];
            amounts.InsertLast(item["amount"]);
            labels.InsertLast("Div " + tostring(int(item["div"])));
        }
    }

    array<float> get_Amounts() const {
        return amounts;
    }

    array<string> get_Labels() const {
        return labels;
    }

    private array<float> amounts;
    private array<string> labels;
}

}