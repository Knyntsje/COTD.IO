namespace Route {

class Router {
    void AddRoute(Base @route) {
        routes.InsertLast(route);
    }

    void Goto(const string &in id, Base @subRoute = null) {
        foreach (Base @route : routes) {
            if (route.Id == id) {
                @pendingRoute = route;
                route.SetSubRoute(subRoute);
                break;
            }
        }
    }

    NavigationState @CaptureNavigation() {
        Base @selected = pendingRoute !is null ? pendingRoute : activeRoute;
        if (selected is null && routes.Length > 0) {
            @selected = routes[0];
        }
        return selected is null ? null : selected.CaptureNavigation();
    }

    void RestoreNavigation(NavigationState @state) {
        @pendingRoute = state.route;
        @activeRoute = state.route;
        state.route.RestoreNavigation(state);
    }

    void Render() {
        UI::BeginTabBar("##routerTabs");

        foreach (Base @route : routes) {
            if (route.Render(@route == @pendingRoute)) {
                @activeRoute = route;
            }
        }
        if (activeRoute is pendingRoute) {
            @pendingRoute = null;
        }
        UI::EndTabBar();
    }

    void Update() {
        if (activeRoute !is null) {
            activeRoute.Update();
        }
    }

    void Reset() {
        if (activeRoute !is null) {
            activeRoute.MarkDataChanged();
        }
    }

    protected array<Base@> routes;
    protected Base @activeRoute;
    protected Base @pendingRoute;
}

}