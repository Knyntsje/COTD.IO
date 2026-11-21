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

        UI::Columns(2, "", false);
        {
            RenderMedianPlayers();
            UI::NextColumn();
            if (UI::TopCups(topCups)) {
                SetSubRoute(Route::TopCups("Most played cups", Route::TopCupsLoadCallback(LoadTopCups)));
            }
        }
        UI::Columns(1);
    }

    private void RenderMedianPlayers() {
        if (medianPlayers !is null && UI::Plot::BeginPlot("Median players per cup", vec2(-1, 300), UI::Plot::PlotFlags::NoInputs)) {
            UI::Plot::SetupAxes("Month", "", UI::Plot::AxisFlags::NoTickMarks, UI::Plot::AxisFlags::AutoFit | UI::Plot::AxisFlags::NoTickMarks);
            UI::Plot::SetupAxisLimits(UI::Plot::Axis::X1, 0.5, 12.5, UI::Plot::Cond::Always);

            if (medianPlayers.ContainsCotd) {
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Day) + " 2025", medianPlayers.CotdLastYear, 0.35, 0.825);
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Day) + " 2026", medianPlayers.CotdThisYear, 0.35, 1.175);        
            }    
            if (medianPlayers.ContainsCotm) {
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Morning) + " 2025", medianPlayers.CotmLastYear, 0.35, 0.825);
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Morning) + " 2026", medianPlayers.CotmThisYear, 0.35, 1.175);        
            }
            if (medianPlayers.ContainsCotn) {
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Night) + " 2025", medianPlayers.CotnLastYear, 0.35, 0.825);
                UI::Plot::PlotBars(Api::CupTypeToDisplayString(Api::e_CupType::Night) + " 2026", medianPlayers.CotnThisYear, 0.35, 1.175);        
            }

            UI::Plot::EndPlot();
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
        @medianPlayers = Api::client.GetCupMedianPlayers(cupTypes);
        topCups = LoadTopCups("", 0, offset);
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

    private array<Api::TopCup@> LoadTopCups(const string &in search, int offset, int &out newOffset) {
        return Api::client.GetCupTopCups(search, cupTypes, offset, newOffset);
    }

    private array<Api::e_CupType> cupTypes;

    private array<Api::TopPlayer@> topWins;
    private array<Api::TopPlayer@> topConsecutiveWins;
    private array<Api::TopPlayer@> topDiv1;
    private array<Api::TopPlayer@> topDiv1Consecutive;
    private Api::MedianPlayers @medianPlayers;
    private array<Api::TopCup@> topCups;

    private UI::TopPlayersRenderer @topPlayersRenderer;
}

}