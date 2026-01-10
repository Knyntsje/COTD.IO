namespace Route {

class StatsCups : Route {
    StatsCups() {
        super("stats/cups", "Cup of the Day");
        @topPlayersRenderer = UI::TopPlayersRenderer();
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        if (UI::CupTypeCombo(cupTypes)) {
            MarkDataChanged();
        }

        if (topPlayersRenderer.Begin()) {
            if (topPlayersRenderer.Render("Most wins", topWins)) {
                SetSubRoute(Route::TopPlayers("Most wins", Route::TopPlayersLoadCallback(LoadTopWins)));
            }

            if (topPlayersRenderer.Render("Most consecutive wins", topConsecutiveWins)) {
                SetSubRoute(Route::TopPlayers("Most consecutive wins", Route::TopPlayersLoadCallback(LoadTopConsecutiveWins)));
            }

            if (topPlayersRenderer.Render("Most div 1", topDiv1)) {
                SetSubRoute(Route::TopPlayers("Most div 1", Route::TopPlayersLoadCallback(LoadTopDiv1)));
            }

            if (topPlayersRenderer.Render("Most consecutive div 1", topDiv1Consecutive)) {
                SetSubRoute(Route::TopPlayers("Most consecutive div 1", Route::TopPlayersLoadCallback(LoadTopDiv1Consecutive)));
            }

            topPlayersRenderer.End();
        }
    }

    protected void Reset() override {
        topWins = topConsecutiveWins = topDiv1 = topDiv1Consecutive = array<Api::TopPlayer@>();
    }

    protected void Load() override {
        int offset = 0;
        topWins = LoadTopWins("", 0, offset);
        topConsecutiveWins = LoadTopConsecutiveWins("", 0, offset);
        topDiv1 = LoadTopDiv1("", 0, offset);
        topDiv1Consecutive = LoadTopDiv1Consecutive("", 0, offset);
    }

    private array<Api::TopPlayer@> LoadTopWins(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetCupTopWins(search, cupTypes, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopConsecutiveWins(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetCupTopConsecutiveWins(search, cupTypes, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopDiv1(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetCupTopDiv1(search, cupTypes, offset, newOffset);
    }

    private array<Api::TopPlayer@> LoadTopDiv1Consecutive(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetCupTopDiv1Consecutive(search, cupTypes, offset, newOffset);
    }

    private array<Api::e_CupType> cupTypes;

    private array<Api::TopPlayer@> topWins;
    private array<Api::TopPlayer@> topConsecutiveWins;
    private array<Api::TopPlayer@> topDiv1;
    private array<Api::TopPlayer@> topDiv1Consecutive;

    private UI::TopPlayersRenderer @topPlayersRenderer;
}

}