namespace Route {

class SubRoute : Route {
    SubRoute(const string &in id, const string &in name) {
        super(id, name);
    }

    bool Render(bool forceActive = false) override {
        if (UI::Button(Icons::ArrowLeft + " Back##route" + id)) {
            parentRoute.SetSubRoute(null);
        }

        UI::SameLine();
        if (UI::Button(Icons::Refresh + "##route" + id)) {
            DataChanged = true;
        }

        UI::SameLine();
        UI::Text(name);

        RenderRoute();
        return forceActive;
    }
}

}