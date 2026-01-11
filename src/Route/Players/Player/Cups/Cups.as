namespace Route {

class PlayerCups : Route {    
    PlayerCups(const Api::Player @_player) {
        super("player/cups", "Cup of the Day");
        @player = _player;
        @infiniteScroll = UI::InfiniteScroll(UI::InfiniteScrollCallback(MarkDirty));
    }

    protected void RenderRoute() override {
        UI::SetNextItemWidth(-1);
        if (UI::CupTypeCombo(cupTypes)) {
            MarkDataChanged();
        }

        if (numberStatsRenderer.Begin(numberStats)) {
            numberStatsRenderer.Render("Cups played", "participated", "played_cups", "total_cups");
            numberStatsRenderer.Render("Division 1", "achieved", "top_64", "played_cups");
            numberStatsRenderer.Render("Divisions 1-2", "achieved", "top_128", "played_cups");
            numberStatsRenderer.Render("Divisions 1-3", "achieved", "top_192", "played_cups");
            numberStatsRenderer.End();
        }

        UI::Columns(2, "", false);
        {
            UI::MedianPositions(medianPositions);
            UI::NextColumn();
            UI::BestPositions(bestPositions);
            UI::NextColumn();        
            RenderDivDistribution();        
            UI::NextColumn();
            RenderPositionDistribution();
        }
        UI::Columns(1);

        if (UI::BeginTable("##cups", 4)) {
            UI::TableSetupColumn("Date");
            UI::TableSetupColumn("Type");
            UI::TableSetupColumn("Track");
            UI::TableSetupColumn("Position");

            UI::TableHeadersRow();
            foreach (const Api::PlayerCup @cup, const int index : cups) {
                if (UI::TableNextColumn()) {
                    UI::Text(Time::FormatStringUTC("%x", cup.StartTs));
                }

                if (UI::TableNextColumn()) {
                    UI::Text(Api::CupTypeToDisplayString(cup.Type));
                }

                if (UI::TableNextColumn()) {
                    if (UI::Selectable(cup.Map.GetDisplayName(), false, UI::SelectableFlags::SpanAllColumns)) {
                        UI::window.Router.Goto("tracks", Route::Cup(Api::Totd(cup), cup.Type));
                    }
                }

                if (UI::TableNextColumn()) {
                    UI::Text(tostring(cup.Position.Get()));
                    UI::SameLine();
                    UI::Text("\\$999Div " + tostring(cup.Position.GetDivision()));
                }
            }

            UI::EndTable();
        }

        if (infiniteScroll.CheckScroll()) {
            UI::Text("\\$999" + Icons::Spinner + " Loading more cups...");
        }
    }

    void RenderDivDistribution() {
        if (divDistribution !is null && UI::Plot::BeginPlot("Division distribution", vec2(-1, 0), UI::Plot::PlotFlags::NoInputs)) {
            UI::Plot::SetupAxes("", "", UI::Plot::AxisFlags::NoDecorations, UI::Plot::AxisFlags::NoDecorations);
            UI::Plot::SetupAxisLimits(UI::Plot::Axis::X1, -1, 1, UI::Plot::Cond::Always);
            UI::Plot::SetupAxisLimits(UI::Plot::Axis::Y1, -1, 1, UI::Plot::Cond::Always);                
            UI::Plot::PlotPieChart(divDistribution.Labels, divDistribution.Amounts, 0.0, 0.0, 0.9, "%.f");                
            UI::Plot::EndPlot();
        }
    }

    void RenderPositionDistribution() {
        if (positionDistribution !is null && UI::Plot::BeginPlot("Position distribution", vec2(-1, 0), UI::Plot::PlotFlags::NoInputs)) {
            UI::Plot::SetupAxes("", "", UI::Plot::AxisFlags::NoDecorations, UI::Plot::AxisFlags::NoDecorations);
            UI::Plot::SetupAxisLimits(UI::Plot::Axis::X1, -1, 1, UI::Plot::Cond::Always);
            UI::Plot::SetupAxisLimits(UI::Plot::Axis::Y1, -1, 1, UI::Plot::Cond::Always);            
            UI::Plot::PlotPieChart(positionDistribution.Labels, positionDistribution.Amounts, 0.0, 0.0, 0.9, "%.f");                
            UI::Plot::EndPlot();
        }
    }

    protected void Reset() override {
        offset = 0;
        cups = array<const Api::PlayerCup@>();
        infiniteScroll.Reset();
    }

    protected void Load() override {
        if (offset == 0) {
            @numberStats = Api::client.GetPlayerCupNumberStats(player.AccountId, cupTypes);
            @medianPositions = Api::client.GetPlayerCupMedianPositions(player.AccountId, cupTypes);
            @bestPositions = Api::client.GetPlayerCupBestPositions(player.AccountId, cupTypes);
            @positionDistribution = Api::client.GetPlayerPositionDistribution(player.AccountId, cupTypes);
            @divDistribution = Api::client.GetPlayerDivDistribution(player.AccountId, cupTypes);
        }

        const array<Api::PlayerCup@> newCups = Api::client.GetPlayerCups(player.AccountId, cupTypes, offset, offset);
        foreach (const Api::PlayerCup @newCup : newCups) {
            cups.InsertLast(newCup);
        }
        infiniteScroll.SetLoadingComplete(newCups.Length > 0);
    }

    private int offset = 0;
    private array<Api::e_CupType> cupTypes;
    private UI::InfiniteScroll @infiniteScroll;

    private UI::NumberStatsRenderer numberStatsRenderer;

    private array<const Api::PlayerCup@> cups;

    private Json::Value @numberStats;
    private Api::MedianPositions @medianPositions;
    private Api::BestPositions @bestPositions;
    private Api::PositionDistribution @positionDistribution;
    private Api::DivDistribution @divDistribution;

    private const Api::Player @player;
}

}