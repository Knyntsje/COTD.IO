namespace Route {

class PlayerTotds : Route {    
    PlayerTotds(const Api::Player @_player) {
        super("player/totds", "Track of the Day");
        @player = _player;
        @infiniteScroll = UI::InfiniteScroll(UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        if (numberStatsRenderer.Begin(numberStats)) {
            numberStatsRenderer.Render("Tracks played", "participated", "played_maps", "total_maps");
            numberStatsRenderer.Render("Top 10", "achieved", "top_10", "played_maps");
            numberStatsRenderer.Render("Top 100", "achieved", "top_100", "played_maps");
            numberStatsRenderer.Render("Top 1000", "achieved", "top_1000", "played_maps");
            numberStatsRenderer.End();
        }

        UI::Columns(2, "", false);
        {
            UI::MedianPositions(medianPositions);
            UI::NextColumn();
            UI::BestPositions(bestPositions);
        }
        UI::Columns(1);

        if (UI::BeginTable("##totds", 3)) {
            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Position");

            UI::TableHeadersRow();
            foreach (const Api::PlayerTotd @totd, const int index : totds) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", totd.DateTs));
                }

                if (UI::TableNextColumn()) {
                    if (UI::Selectable(totd.Map.GetDisplayName(), false, UI::SelectableFlags::SpanAllColumns)) {
                        UI::window.Router.Goto("tracks", Route::Totd(totd));
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(totd.Position.Get()));
                }
            }

            UI::EndTable();
        }

        if (infiniteScroll.CheckScroll()) {
            UI::Text("\\$999" + Icons::Spinner + " Loading more tracks...");
        }
    }

    protected void Reset() override {
        offset = 0;
        totds = array<const Api::PlayerTotd@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        if (offset == 0) {
            @numberStats = Api::client.GetPlayerTotdNumberStats(player.AccountId);
            @medianPositions = Api::client.GetPlayerTotdMedianPositions(player.AccountId);
            @bestPositions = Api::client.GetPlayerTotdBestPositions(player.AccountId);
        }

        const array<Api::PlayerTotd@> newTotds = Api::client.GetPlayerTotds(player.AccountId, offset, offset);
        foreach (const Api::PlayerTotd @newTotd : newTotds) {
            totds.InsertLast(newTotd);
        }
        infiniteScroll.SetLoadingComplete(newTotds.Length > 0);
    }

    private int offset = 0;
    private UI::InfiniteScroll @infiniteScroll;

    private UI::NumberStatsRenderer numberStatsRenderer;

    private array<const Api::PlayerTotd@> totds;

    private Json::Value @numberStats;
    private Api::MedianPositions @medianPositions;
    private Api::BestPositions @bestPositions;

    private const Api::Player @player;
}

}