namespace Route {

class Cup : SubRoute {
    Cup(const Api::Totd @_totd, const Api::e_CupType &in _cupType) {
        super("cup", Api::CupTypeToDisplayString(_cupType) + " " + Time::FormatStringUTC("%x", _totd.DateTs) + " - " + _totd.Map.GetDisplayName());
        @totd = _totd;
        @cupDataEntry = _totd.CupData.GetCupDataEntry(_cupType);

        @router = Router();
        router.AddRoute(Route::CupLeaderboard(cupDataEntry));
        router.AddRoute(Route::CupQualifierLeaderboard(totd.Map, cupDataEntry));
    }

    void Update() override {
        router.Update();
        SubRoute::Update();
    }

    protected void RenderRoute() override {
        UI::Text("Players: " + tostring(cupDataEntry.NumPlayers));
        UI::SameLine();
        UI::Text("Author: " + Api::MedalToColor(Api::e_Medal::Author) + Time::Format(totd.Map.AuthorScore));
        UI::SameLine();
        UI::Text("Gold: " + Api::MedalToColor(Api::e_Medal::Gold) + Time::Format(totd.Map.GoldScore));
        UI::SameLine();
        UI::Text("Silver: " + Api::MedalToColor(Api::e_Medal::Silver) + Time::Format(totd.Map.SilverScore));
        UI::SameLine();
        UI::Text("Bronze: " + Api::MedalToColor(Api::e_Medal::Bronze) + Time::Format(totd.Map.BronzeScore));

        router.Render();
    }

    protected void Reset() override {
        router.Reset();
    }

    protected void Load() override {}

    private const Api::Totd @totd;
    private Api::CupDataEntry @cupDataEntry;
    private Router @router;
}

}