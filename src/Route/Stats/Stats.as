namespace Route {

class Stats : Route {
    Stats() {
        super("stats", Icons::Home + " Stats");
    }

    protected void RenderRoute() override {
        UI::Text("Stats");
    }

    protected void Load() override {
        // TODO: Implement
    }
}

}