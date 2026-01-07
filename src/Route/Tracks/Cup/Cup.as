namespace Route {

class Cup : SubRoute {
    Cup(const Api::Totd @_totd, const Api::e_CupType &in _cupType) {
        super("cup", Api::CupTypeToDisplayString(_cupType) + " " + Time::FormatStringUTC("%x", _totd.DateTs) + " - " + _totd.Map.GetDisplayName());
        @totd = _totd;
        @cupDataEntry = _totd.CupData.GetCupDataEntry(_cupType);

        @router = Router();
        router.AddRoute(Route::CupLeaderboard(cupDataEntry));
        router.AddRoute(Route::CupQualifierLeaderboard(cupDataEntry));
    }

    void Update() override {
        router.Update();
        SubRoute::Update();
    }

    protected void RenderRoute() override {
        UI::Text("Players: " + tostring(cupDataEntry.NumPlayers));
        UI::SameLine();
        UI::Text("Author: \\$0f0" + Time::Format(totd.Map.AuthorScore));
        UI::SameLine();
        UI::Text("Gold: \\$fd0" + Time::Format(totd.Map.GoldScore));
        UI::SameLine();
        UI::Text("Silver: \\$ccc" + Time::Format(totd.Map.SilverScore));
        UI::SameLine();
        UI::Text("Bronze: \\$f80" + Time::Format(totd.Map.BronzeScore));

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