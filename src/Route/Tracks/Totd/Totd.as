namespace Route {

class Totd : SubRoute {
    Totd(const Api::Totd @_totd) {
        super("totd", "TOTD " + Time::FormatStringUTC("%x", _totd.DateTs) + " - " + _totd.Map.GetDisplayName());
        @totd = _totd;

        @infiniteScroll = UI::InfiniteScrollTable("##leaderboard", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::Text("Author: " + Api::MedalToColor(Api::e_Medal::Author) + Time::Format(totd.Map.AuthorScore));
        UI::SameLine();
        UI::Text("Gold: " + Api::MedalToColor(Api::e_Medal::Gold) + Time::Format(totd.Map.GoldScore));
        UI::SameLine();
        UI::Text("Silver: " + Api::MedalToColor(Api::e_Medal::Silver) + Time::Format(totd.Map.SilverScore));
        UI::SameLine();
        UI::Text("Bronze: " + Api::MedalToColor(Api::e_Medal::Bronze) + Time::Format(totd.Map.BronzeScore));

        if (UI::Button(Icons::Refresh + "##" + id + "refresh")) {
            DataChanged = true;
        }

        UI::SameLine();
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by player name, tag, etc...", search, DataChanged);        

        if (infiniteScroll.Begin(5)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("");
            UI::TableSetupColumn("Player");
            UI::TableSetupColumn("Time");
            UI::TableSetupColumn("When");
            UI::TableSetupColumn("");

            UI::TableHeadersRow();
            foreach (const Api::MapLeaderboardEntry @entry, const int index : leaderboard) {
                if (UI::TableNextColumn()) {
                    UI::Text(tostring(entry.Position));
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
                    UI::Text(Api::MedalToColor(entry.Medal) + Time::Format(entry.Score));
                    if (index > 0) {
                        UI::SameLine();
                        UI::Text("\\$999(+" + Time::Format(entry.Score - leaderboard[0].Score) + ")");
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(entry.When);
                }

                if (UI::TableNextColumn()) {
                    if (UI::Button(Icons::Download + "##" + entry.MapRecordId + "download")) {
                        OpenBrowserURL("https://cotd.io/api/download/ghost/" + entry.MapRecordId);
                    }
                }
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        leaderboard = array<const Api::MapLeaderboardEntry@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::MapLeaderboardEntry@> newLeaderboard = Api::client.GetMapLeaderboard(totd.Map.Uid, search, offset, offset);
        foreach (const Api::MapLeaderboardEntry @newLeaderboardEntry : newLeaderboard) {
            leaderboard.InsertLast(newLeaderboardEntry);
        }
        infiniteScroll.SetLoadingComplete(newLeaderboard.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::MapLeaderboardEntry@> leaderboard;
    private const Api::Totd @totd;
}

}