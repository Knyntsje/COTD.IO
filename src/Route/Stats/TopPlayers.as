namespace Route {

funcdef array<Api::TopPlayer@> TopPlayersLoadCallback(const string &in search, int offset, int &out newOffset);

class TopPlayers : SubRoute {
    TopPlayers(const string &in title, const TopPlayersLoadCallback @_loadCallback) {
        super("topPlayers", title);
        @loadCallback = _loadCallback;
        @infiniteScroll = UI::InfiniteScrollTable("##" + id, UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by player name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(3)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("");
            UI::TableSetupColumn("Player");
            UI::TableSetupColumn("Quantity");

            UI::TableHeadersRow();

            foreach (const Api::TopPlayer @topPlayer : topPlayers) {
                if (UI::TableNextColumn()) {
                    UI::Text(tostring(topPlayer.Position));
                }

                if (UI::TableNextColumn()) {
                    if (topPlayer.Player.Avatar !is null) {
                        UI::Image(topPlayer.Player.Avatar);
                        UI::SameLine();
                    }

                    if (UI::ClickableText(topPlayer.Player.GetDisplayName())) {
                        UI::window.Router.Goto("players", Route::Player(topPlayer.Player));
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(topPlayer.Quantity));
                }
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        topPlayers = array<const Api::TopPlayer@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::TopPlayer@> newTopPlayers = loadCallback(search, offset, offset);
        foreach (const Api::TopPlayer @newTopPlayer : newTopPlayers) {
            topPlayers.InsertLast(newTopPlayer);
        }
        infiniteScroll.SetLoadingComplete(newTopPlayers.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::TopPlayer@> topPlayers;

    const TopPlayersLoadCallback @loadCallback;
}

}