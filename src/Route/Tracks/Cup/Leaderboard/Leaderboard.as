namespace Route {

class CupLeaderboard : Route {
    CupLeaderboard(const Api::CupDataEntry @_cupDataEntry) {
        super("cup/leaderboard", "Leaderboard");
        @cupDataEntry = _cupDataEntry;

        @infiniteScroll = UI::InfiniteScrollTable("##leaderboard", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by player name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(4)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("##position");
            UI::TableSetupColumn("Player");

            UI::TableHeadersRow();
            foreach (const Api::CotdLeaderboardEntry @entry : leaderboard) {
                if (UI::TableNextColumn()) {
                    UI::Text(tostring(entry.Position.Get()));
                    UI::SameLine();
                    UI::Text("\\$999Div " + tostring(entry.Position.GetDivision()));
                }

                if (UI::TableNextColumn()) {
                    if (entry.Player.Avatar !is null) {
                        UI::Image(entry.Player.Avatar);
                        UI::SameLine();
                    }

                    if (UI::ClickableText(entry.Player.GetDisplayName())) {
                        UI::window.Router.Goto("players", Route::Player(entry.Player));
                    }
                }

                UI::TableNextRow();
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        leaderboard = array<const Api::CotdLeaderboardEntry@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::CotdLeaderboardEntry@> newLeaderboard = Api::client.GetCotdLeaderboard(cupDataEntry.Id, search, offset, offset);
        foreach (const Api::CotdLeaderboardEntry @newLeaderboardEntry : newLeaderboard) {
            leaderboard.InsertLast(newLeaderboardEntry);
        }
        infiniteScroll.SetLoadingComplete(newLeaderboard.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::CotdLeaderboardEntry@> leaderboard;
    private const Api::CupDataEntry @cupDataEntry;
}

}