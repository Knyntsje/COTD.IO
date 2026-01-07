namespace Route {

class Route {
    Route(const string &in _id, const string &in _name) {
        id = _id;
        name = _name;
        isDirty = true;
    }

    string get_Id() {
        return id;
    }

    string get_Name() {
        return name;
    }

    void Update() {
        if (subRoute !is null) {
            subRoute.Update();
        }

        if (dataChanged) {
            Reset();
            dataChanged = false;
            isDirty = true;
        }

        if (isDirty) {
            Load();
            isDirty = false;
        }
    }

    void MarkDataChanged() {
        dataChanged = true;
    }

    void MarkDirty() {
        isDirty = true;
    }

    bool Render(bool forceActive = false) {
        bool isActive = false;
        if (UI::BeginTabItem(name, forceActive ? UI::TabItemFlags::SetSelected : UI::TabItemFlags::None)) {
            isActive = true;
            if (UI::BeginChild("##" + name + "##route")) {
                if (subRoute !is null) {
                    subRoute.Render(forceActive);
                }
                else {
                    RenderRoute();
                }
                UI::EndChild();
            }
            UI::EndTabItem();
        }
        return isActive;
    }

    void SetSubRoute(Route @_subRoute) {
        if (_subRoute !is null) {
            _subRoute.SetParentRoute(this);
        }

        @subRoute = _subRoute;
    }

    protected void SetParentRoute(Route @_parentRoute) {
        @parentRoute = _parentRoute;
    }

    protected void RenderRoute() {
        throw("Route::RenderRoute not implemented");
    }

    protected void Reset() {
        throw("Route::Reset not implemented");
    }

    protected void Load() {
        throw("Route::Load not implemented");
    }

    protected bool get_DataChanged() {
        return dataChanged;
    }

    protected void set_DataChanged(bool _dataChanged) {
        if (_dataChanged) {
            dataChanged = true;
        }
    }

    protected bool isDirty;
    protected bool dataChanged;

    protected Route @subRoute;
    protected Route @parentRoute;

    protected string id;
    protected string name;
}

}