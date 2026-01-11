namespace Route {

funcdef array<Api::TopCup@> TopCupsLoadCallback(const string &in search, int offset, int &out newOffset);

class TopCups : SubRoute {
    TopCups(const string &in title, const TopCupsLoadCallback @_loadCallback) {
        super("topCups", title);
        @loadCallback = _loadCallback;
        @infiniteScroll = UI::InfiniteScrollTable("##" + id, UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        search = UI::InputTextWithHint("##search", "Search by track name, author name, tag, etc...", search, DataChanged);

        if (infiniteScroll.Begin(5)) {
            UI::TableSetupScrollFreeze(0, 1);

            UI::TableSetupColumn("");
            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Type");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Players");

            UI::TableHeadersRow();

            foreach (const Api::TopCup @topCup : topCups) {
                if (UI::TableNextColumn()) {
                    UI::Text(tostring(topCup.Position));
                }
                
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", topCup.StartTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(Api::CupTypeToDisplayString(topCup.Type));
                }

                if (UI::TableNextColumn()) {
                    if (UI::ClickableText(topCup.Map.GetDisplayName())) {
                        UI::window.Router.Goto("tracks", Route::Cup(Api::Totd(topCup), topCup.Type));
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(topCup.NumPlayers));
                }
            }

            infiniteScroll.End();
        }
    }

    protected void Reset() override {
        offset = 0;
        topCups = array<const Api::TopCup@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        const array<Api::TopCup@> newTopCups = loadCallback(search, offset, offset);
        foreach (const Api::TopCup @newTopCup : newTopCups) {
            topCups.InsertLast(newTopCup);
        }
        infiniteScroll.SetLoadingComplete(newTopCups.Length > 0);
    }

    private string search = "";
    private int offset = 0;
    private UI::InfiniteScrollTable @infiniteScroll;

    private array<const Api::TopCup@> topCups;

    const TopCupsLoadCallback @loadCallback;
}

}