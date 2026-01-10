namespace Route {

class Router {
    void AddRoute(Route @route) {
        routes.InsertLast(route);
    }

    void Goto(const string &in id, Route @subRoute = null) {
        foreach (Route @route : routes) {
            if (route.Id == id) {
                @pendingNavigateRoute = route;
                route.SetSubRoute(subRoute);
                break;
            }
        }
    }

    void Render() {
        UI::BeginTabBar("##routerTabs");        
        foreach (Route @route : routes) {
            if (route.Render(@route == @pendingNavigateRoute)) {
                @activeRoute = route;
            }

            if (@activeRoute == @pendingNavigateRoute) {
                @pendingNavigateRoute = null;
            }
        }
        UI::EndTabBar();
    }

    void Update() {
        foreach (Route @route : routes) {
            if (@route == @activeRoute) {
                route.Update();
            }
        }
    }

    void Reset() {
        foreach (Route @route : routes) {
            if (@route == @activeRoute) {
                route.MarkDataChanged();
            }
        }
    }

    protected array<Route@> routes;
    protected Route @activeRoute;
    protected Route @pendingNavigateRoute;
}

}