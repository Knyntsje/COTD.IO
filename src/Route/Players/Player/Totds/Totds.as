namespace Route {

class PlayerTotds : Route {    
    PlayerTotds(const Api::Player @_player) {
        super("player/totds", "Track of the Day");
        @player = _player;
        @infiniteScroll = UI::InfiniteScrollTable("##totds", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        if (infiniteScroll.Begin(5)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Position");
            UI::TableSetupColumn("");

            UI::TableHeadersRow();
            foreach (const Api::PlayerTotd @totd, const int index : totds) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", totd.DateTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(totd.Map.GetDisplayName());
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(totd.Position.Get()));
                }

                if (UI::TableNextColumn()) {
                    if (UI::Button(Icons::Eye + "##totd" + index)) {
                        UI::window.Router.Goto("tracks", Route::Totd(totd));
                    }
                }

                UI::TableNextRow();
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        totds = array<const Api::PlayerTotd@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::PlayerTotd@> newTotds = Api::client.GetPlayerTotds(player.AccountId, offset, offset);
        foreach (const Api::PlayerTotd @newTotd : newTotds) {
            totds.InsertLast(newTotd);
        }
        infiniteScroll.SetLoadingComplete(newTotds.Length > 0);
    }

    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::PlayerTotd@> totds;
    private const Api::Player @player;
}

}