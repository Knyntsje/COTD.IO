namespace UI {

class NumberStatsRenderer : ColumnRenderer {
    NumberStatsRenderer() {
        super(160.f, 4);
    }

    bool Begin(const Json::Value @&in _data) {
        if (_data is null || _data.GetType() != Json::Type::Object) {
            return false;
        }

        @data = _data;
        return ColumnRenderer::Begin();
    }

    void Render(const string &in title, const string &in percentageLabel, const string &in valueKey, const string &in totalKey) {
        if (!data.HasKey(valueKey) || !data.HasKey(totalKey)) {
            return;
        }

        const int value = data[valueKey];
        const int total = data[totalKey];

        if (UI::BeginChild("##numberStat" + title, vec2(-1, 80.f))) {
            UI::Text(title);
            UI::PushFontSize(32);
            UI::Text(value + " \\$999/ " + total);
            UI::PopFontSize();
            UI::Text("\\$999" + (total > 0 ? Text::Format("%.1f", float(value) / float(total) * 100.f) : "0") + "% " + percentageLabel);
        }
        UI::EndChild();
        ColumnRenderer::Render();
    }

    private const Json::Value @data;
}

}