namespace Route {

class PlayerCups : Route {    
    PlayerCups(const Api::Player @_player) {
        super("player/cups", "Cup of the Day");
        @player = _player;
        @infiniteScroll = UI::InfiniteScrollTable("##cups", UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        if (UI::CupTypeCombo(cupTypes)) {
            MarkDataChanged();
        }

        if (infiniteScroll.Begin(5)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Type");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Position");
            UI::TableSetupColumn("");

            UI::TableHeadersRow();
            foreach (const Api::PlayerCup @cup, const int index : cups) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", cup.StartTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(Api::CupTypeToDisplayString(cup.Type));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(cup.Map.GetDisplayName());
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(cup.Position.Get()));
                    UI::SameLine();
                    UI::Text("\\$999Div " + tostring(cup.Position.GetDivision()));
                }

                if (UI::TableNextColumn()) {
                    if (UI::Button(Icons::Eye + "##cup" + index)) {
                        UI::window.Router.Goto("tracks", Route::Cup(Api::Totd(cup), cup.Type));
                    }
                }

                UI::TableNextRow();
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        cups = array<const Api::PlayerCup@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::PlayerCup@> newCups = Api::client.GetPlayerCups(player.AccountId, cupTypes, offset, offset);
        foreach (const Api::PlayerCup @newCup : newCups) {
            cups.InsertLast(newCup);
        }
        infiniteScroll.SetLoadingComplete(newCups.Length > 0);
    }

    private int offset = 0;
    private array<Api::e_CupType> cupTypes;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::PlayerCup@> cups;
    private const Api::Player @player;
}

}