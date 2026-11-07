namespace Route {

class Players : Route {    
    Players() {
        super("players", Icons::User + " Players");
        @infiniteScroll = UI::InfiniteScrollTable("##players", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        if (UI::Button(Icons::Refresh + "##" + id + "refresh")) {
            DataChanged = true;
        }

        UI::SameLine();
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by player name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(1)) {
            UI::TableSetupScrollFreeze(0, 1);
            UI::TableSetupColumn("Player");

            UI::TableHeadersRow();
            UI::ListClipper clipper(int(players.Length));
            while (clipper.Step()) {
                for (int index = clipper.DisplayStart; index < clipper.DisplayEnd; ++index) {
                    const Api::Player @player = players[index];
                    if (UI::TableNextColumn()) {
                        UI::PlayerAvatar(player);

                        if (UI::Selectable(player.GetDisplayName() + "##" + player.AccountId, false, UI::SelectableFlags::SpanAllColumns)) {
                            SetSubRoute(::Route::Player(player));
                        }
                    }
                }
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        players = array<const Api::Player@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::Player@> newPlayers = Api::client.GetPlayers(search, array<string>(), offset, offset);
        foreach (const Api::Player @newPlayer : newPlayers) {
            players.InsertLast(newPlayer);
        }
        infiniteScroll.SetLoadingComplete(newPlayers.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::Player@> players;
}

}