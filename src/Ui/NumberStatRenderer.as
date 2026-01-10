namespace UI {

class NumberStatRenderer {
    bool Begin(const Json::Value @&in _data) {
        if (@_data is null || _data.GetType() != Json::Type::Object) {
            return false;
        }

        numColumns = int(Math::Clamp(UI::GetContentRegionAvail().x / 160.f, 1.f, 4.f));
        UI::Columns(numColumns, "", false);

        @data = _data;
        return true;
    }

    void Render(const string &in title, const string &in percentageLabel, const string &in valueKey, const string &in totalKey) {
        if (!data.HasKey(valueKey) || !data.HasKey(totalKey)) {
            return;
        }

        const int value = data[valueKey];
        const int total = data[totalKey];

        if (UI::BeginChild("##numberStat" + title, vec2(-1, 100.f), UI::ChildFlags::Border)) {
            UI::Text(title);
            UI::PushFont(null, 32);
            UI::Text(value + " \\$999/ " + total);
            UI::PopFont();
            UI::Text("\\$999" + (total > 0 ? Text::Format("%.1f", float(value) / float(total) * 100.f) : "0") + "% " + percentageLabel);
        }
        UI::EndChild();
        UI::NextColumn();
    }

    void End() {
        UI::Columns(1);
    }

    private int numColumns = 0;
    private const Json::Value @data;
}

}