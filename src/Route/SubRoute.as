namespace Route {

class SubRoute : Route {
    SubRoute(const string &in id, const string &in name) {
        super(id, name);
    }

    bool Render(bool forceActive = false) override {
        bool isActive = true;
        if (UI::Button(Icons::ArrowLeft + " Back##route" + id)) {
            isActive = false;
        }

        UI::SameLine();
        if (UI::Button(Icons::Refresh + "##route" + id)) {
            MarkDataChanged();
        }

        UI::SameLine();
        UI::Text(name);

        RenderRoute();
        return isActive;
    }
}

}