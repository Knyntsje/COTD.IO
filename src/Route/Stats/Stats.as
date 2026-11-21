namespace Route {

class Stats : Base {
    Stats() {
        super("stats", Icons::Home + " Stats");

        @router = Router();
        router.AddRoute(Route::StatsCups());
        router.AddRoute(Route::StatsTotds());
    }

    Router @GetNavigationRouter() override {
        return router;
    }

    void Update() override {
        router.Update();
        Base::Update();
    }

    protected void RenderRoute() override {
        if (UI::Button(Icons::Refresh + "##statsRefresh")) {
            MarkDataChanged();
        }
        UI::SameLine();
        router.Render();
    }

    protected void Reset() override {
        router.Reset();
    }

    protected void Load() override {}

    private Router @router;
}

}