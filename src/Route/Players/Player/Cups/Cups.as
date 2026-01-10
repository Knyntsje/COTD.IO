namespace Route {

class PlayerCups : Route {    
    PlayerCups(const Api::Player @_player) {
        super("player/cups", "Cup of the Day");
        @player = _player;
        @infiniteScroll = UI::InfiniteScroll(UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        if (UI::CupTypeCombo(cupTypes)) {
            MarkDataChanged();
        }

        if (numberStatsRenderer.Begin(numberStats)) {
            numberStatsRenderer.Render("Cups played", "participated", "played_cups", "total_cups");
            numberStatsRenderer.Render("Division 1", "achieved", "top_64", "played_cups");
            numberStatsRenderer.Render("Divisions 1-2", "achieved", "top_128", "played_cups");
            numberStatsRenderer.Render("Divisions 1-3", "achieved", "top_192", "played_cups");
            numberStatsRenderer.End();
        }

        if (UI::BeginTable("##cups", 4)) {
            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Type");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Position");

            UI::TableHeadersRow();
            foreach (const Api::PlayerCup @cup, const int index : cups) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", cup.StartTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(Api::CupTypeToDisplayString(cup.Type));
                }

                if (UI::TableNextColumn()) {
                    if (UI::Selectable(cup.Map.GetDisplayName(), false, UI::SelectableFlags::SpanAllColumns)) {
                        UI::window.Router.Goto("tracks", Route::Cup(Api::Totd(cup), cup.Type));
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(cup.Position.Get()));
                    UI::SameLine();
                    UI::Text("\\$999Div " + tostring(cup.Position.GetDivision()));
                }
            }

            UI::EndTable();
        }

        if (infiniteScroll.CheckScroll()) {
            UI::Text("\\$999" + Icons::Spinner + " Loading more cups...");
        }
    }

    protected void Reset() override {
        offset = 0;
        cups = array<const Api::PlayerCup@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        if (offset == 0) {
            @numberStats = Api::client.GetPlayerCupNumberStats(player.AccountId, cupTypes);
        }

        const array<Api::PlayerCup@> newCups = Api::client.GetPlayerCups(player.AccountId, cupTypes, offset, offset);
        foreach (const Api::PlayerCup @newCup : newCups) {
            cups.InsertLast(newCup);
        }
        infiniteScroll.SetLoadingComplete(newCups.Length > 0);
    }

    private int offset = 0;
    private array<Api::e_CupType> cupTypes;
    private UI::InfiniteScroll @infiniteScroll;

    private UI::NumberStatsRenderer numberStatsRenderer;

    private array<const Api::PlayerCup@> cups;
    private Json::Value @numberStats;
    private const Api::Player @player;
}

}