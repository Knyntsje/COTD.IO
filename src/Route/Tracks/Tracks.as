namespace Route {

class Tracks : Route {    
    Tracks() {
        super("tracks", Icons::Map + " Tracks");
        @infiniteScroll = UI::InfiniteScrollTable("##tracks", UI::InfiniteScrollCallback(MarkDirty));

        timeInfo = Time::Parse(Time::Stamp);
        selectedYear = timeInfo.Year;
        selectedMonth = timeInfo.Month;

        monthNames.InsertLast("January");
        monthNames.InsertLast("February");
        monthNames.InsertLast("March");
        monthNames.InsertLast("April");
        monthNames.InsertLast("May");
        monthNames.InsertLast("June");
        monthNames.InsertLast("July");
        monthNames.InsertLast("August");
        monthNames.InsertLast("September");
        monthNames.InsertLast("October");
        monthNames.InsertLast("November");
        monthNames.InsertLast("December");
    }

    protected void RenderRoute() override {
        if (UI::Button(Icons::Refresh + "##" + id + "refresh")) {
            DataChanged = true;
        }

        UI::SameLine();

        if (UI::Button(Icons::Calendar + "##month")) {
            UI::OpenPopup("##monthPopup");
        }

        if (UI::BeginPopup("##monthPopup")) {
            if (UI::BeginCombo("Year", tostring(selectedYear))) {
                for (int year = 2020; year <= timeInfo.Year; year++) {
                    if (UI::Selectable(tostring(year), selectedYear == year)) {
                        selectedYear = year;
                        // First cup was in July 2020
                        if (selectedYear == 2020 && selectedMonth < 7) {
                            selectedMonth = 7;
                        }
                        MarkDataChanged();
                    }
                }
                UI::EndCombo();
            }
            if (UI::BeginCombo("Month", monthNames[selectedMonth - 1])) {
                // First cup was in July 2020
                const int startMonth = selectedYear == 2020 ? 7 : 1;
                for (int month = startMonth; month <= 12; month++) {
                    if (UI::Selectable(monthNames[month - 1], selectedMonth == month)) {
                        selectedMonth = month;
                        MarkDataChanged();
                    }
                }
                UI::EndCombo();
            }
            UI::EndPopup();
        }

        UI::SameLine();
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by track name, author name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(7)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Map");
            UI::TableSetupColumn("Author");
            UI::TableSetupColumn("COTD");
            UI::TableSetupColumn("COTN");
            UI::TableSetupColumn("COTM");
            UI::TableSetupColumn("TOTD");

            UI::TableHeadersRow();
            foreach (const Api::Totd @totd, const int index : totds) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", totd.DateTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(totd.Map.GetDisplayName());
                }

                if (UI::TableNextColumn()) {
                    if (UI::ClickableText(totd.Map.Author.GetDisplayName())) {
                        UI::window.Router.Goto("players", Route::Player(totd.Map.Author));
                    }
                }

                if (UI::TableNextColumn()) {
                    if (totd.CupData.Day !is null) {
                        if (UI::Button(Icons::Trophy + " " + tostring(totd.CupData.Day.NumPlayers) + "##day" + index)) {
                            SetSubRoute(Route::Cup(totd, Api::e_CupType::Day));
                        }
                    }
                    else {
                        UI::Text("-");
                    }
                }

                if (UI::TableNextColumn()) {
                    if (totd.CupData.Night !is null) {
                        if (UI::Button(Icons::Trophy + " " + tostring(totd.CupData.Night.NumPlayers) + "##night" + index)) {
                            SetSubRoute(Route::Cup(totd, Api::e_CupType::Night));
                        }
                    }
                    else {
                        UI::Text("-");
                    }
                }

                if (UI::TableNextColumn()) {
                    if (totd.CupData.Morning !is null) {
                        if (UI::Button(Icons::Trophy + " " + tostring(totd.CupData.Morning.NumPlayers) + "##morning" + index)) {
                            SetSubRoute(Route::Cup(totd, Api::e_CupType::Morning));
                        }
                    }
                    else {
                        UI::Text("-");
                    }
                }

                if (UI::TableNextColumn()) {
                    if (UI::Button(Icons::Map + "##totd" + index)) {
                        SetSubRoute(Route::Totd(totd));
                    }
                }

                UI::TableNextRow();
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        totds = array<const Api::Totd@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::Totd@> newTotds = Api::client.GetTotds(search, selectedYear, selectedMonth - 1, offset, offset);
        foreach (const Api::Totd @newTotd : newTotds) {
            totds.InsertLast(newTotd);
        }
        infiniteScroll.SetLoadingComplete(newTotds.Length > 0);
    }

    private string search = "";
    private int selectedYear;
    private int selectedMonth;

    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::Totd@> totds;

    private Time::Info timeInfo;
    private array<string> monthNames;
}

}