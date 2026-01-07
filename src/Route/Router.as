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
            const bool forceActive = @route == @pendingNavigateRoute;
            if (route.Render(forceActive)) {
                @activeRoute = route;
            }

            if (forceActive) {
                @pendingNavigateRoute = null;
            }
        }
       
        UI::EndTabBar();
    }

    void Update() {
        if (activeRoute !is null) {
            activeRoute.Update();
        }
    }

    void Reset() {
        foreach (Route @route : routes) {
            route.MarkDataChanged();
        }
    }

    protected array<Route@> routes;
    protected Route @activeRoute;
    protected Route @pendingNavigateRoute;
}

}