namespace Route {

class StatsTotds : Route {
    StatsTotds() {
        super("stats/totds", "Track of the Day");
        @topPlayersRenderer = UI::TopPlayersRenderer();
    }

    protected void RenderRoute() override {
        if (topPlayersRenderer.Begin()) {
            if (topPlayersRenderer.Render("Most world records", topWrs)) {
                SetSubRoute(Route::TopPlayers("Most world records", Route::TopPlayersLoadCallback(LoadTopWrs)));
            }

            if (topPlayersRenderer.Render("Most top 10", topTop10s)) {
                SetSubRoute(Route::TopPlayers("Most top 10", Route::TopPlayersLoadCallback(LoadTopTop10s)));
            }

            if (topPlayersRenderer.Render("Most top 100", topTop100s)) {
                SetSubRoute(Route::TopPlayers("Most top 100", Route::TopPlayersLoadCallback(LoadTopTop100s)));
            }

            if (topPlayersRenderer.Render("Most top 1000", topTop1000s)) {
                SetSubRoute(Route::TopPlayers("Most top 1000", Route::TopPlayersLoadCallback(LoadTopTop1000s)));
            }
            topPlayersRenderer.End();
        }
    }

    protected void Reset() override {
        topWrs = topTop10s = topTop100s = topTop1000s = array<Api::TopPlayer@>();
    }

    protected void Load() override {
        int offset = 0;
        topWrs = LoadTopWrs("", 0, offset);
        topTop10s = LoadTopTop10s("", 0, offset);
        topTop100s = LoadTopTop100s("", 0, offset);
        topTop1000s = LoadTopTop1000s("", 0, offset);
    }

    private array<Api::TopPlayer@> LoadTopWrs(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetTotdTopWrs(search, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopTop10s(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetTotdTopTop10s(search, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopTop100s(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetTotdTopTop100s(search, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopTop1000s(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetTotdTopTop1000s(search, offset, newOffset);
    }

    private array<Api::TopPlayer@> topWrs;
    private array<Api::TopPlayer@> topTop10s;
    private array<Api::TopPlayer@> topTop100s;
    private array<Api::TopPlayer@> topTop1000s;

    private UI::TopPlayersRenderer @topPlayersRenderer;
}

}