namespace Route {

class CupQualifierLeaderboard : Route {
    CupQualifierLeaderboard(const Api::CupDataEntry @_cupDataEntry) {
        super("cup/qualifierleaderboard", "Qualifier");
        @cupDataEntry = _cupDataEntry;

        @infiniteScroll = UI::InfiniteScrollTable("##qualifierleaderboard", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by player name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(4)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("##position");
            UI::TableSetupColumn("Player");
            UI::TableSetupColumn("Time");

            UI::TableHeadersRow();
            foreach (const Api::CotdQualifierLeaderboardEntry @entry, const int index : leaderboard) {
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

                if (UI::TableNextColumn()) {
                    UI::Text(Time::Format(entry.Score));
                    if (index > 0) {
                        UI::SameLine();
                        UI::Text("\\$999(+" + Time::Format(entry.Score - leaderboard[0].Score) + ")");
                    }
                }

                UI::TableNextRow();
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        leaderboard = array<const Api::CotdQualifierLeaderboardEntry@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::CotdQualifierLeaderboardEntry@> newLeaderboard = Api::client.GetCotdQualifierLeaderboard(cupDataEntry.Id, search, offset, offset);
        foreach (const Api::CotdQualifierLeaderboardEntry @newLeaderboardEntry : newLeaderboard) {
            leaderboard.InsertLast(newLeaderboardEntry);
        }
        infiniteScroll.SetLoadingComplete(newLeaderboard.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::CotdQualifierLeaderboardEntry@> leaderboard;
    private const Api::CupDataEntry @cupDataEntry;
}

}