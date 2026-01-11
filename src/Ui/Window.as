namespace UI {

class Window {
    Window() {
        @router = Route::Router();
        router.AddRoute(Route::Stats());
        router.AddRoute(Route::Tracks());
        router.AddRoute(Route::Players());

        isOpen = dev.IsDevBuild;
    }

    bool GetIsOpen() {
        return isOpen;
    }

    void Toggle() {
        isOpen = !isOpen;
    }

    void Render() {
        if (!isOpen) return;

        UI::SetNextWindowSize(800, 500);

        const bool showMenuBar = dev.IsDevBuild || player !is null;

        int flags = UI::WindowFlags::NoCollapse;
        if (showMenuBar) {
            flags |= UI::WindowFlags::MenuBar;
        }

        bool reset = false;
        if (UI::Begin(Icons::Trophy + " COTD.IO", isOpen, flags)) {
            if (showMenuBar && UI::BeginMenuBar()) {
                if (dev.IsDevBuild) {
                    if (UI::BeginMenu("Dev")) {
                        if (UI::MenuItem("Local API", "", Settings::Dev::USE_LOCAL_API)) {
                            Settings::Dev::USE_LOCAL_API = !Settings::Dev::USE_LOCAL_API;
                            reset = true;
                        }
                        if (UI::MenuItem("Log API Requests", "", Settings::Dev::LOG_API_REQUESTS)) {
                            Settings::Dev::LOG_API_REQUESTS = !Settings::Dev::LOG_API_REQUESTS;
                        }
                        UI::EndMenu();
                    }
                }

                if (player !is null) {
                    if (UI::MenuItem(player.GetDisplayName())) {
                        router.Goto("players", Route::Player(player));
                    }
                }
                UI::EndMenuBar();
            }

            router.Render();
            UI::End();
        }

        if (reset) {
            @Api::client = Api::Client();
            @window = Window();
        }
    }

    void Update() {
        if (!loadedPlayer) {
            @player = Api::client.GetPlayer(NadeoServices::GetAccountID());
            loadedPlayer = true;
        }

        if (isOpen) {
            router.Update(); 
        }
    }

    Route::Router @get_Router() {
        return router;
    }

    private bool isOpen;
    private Route::Router @router;

    private Api::Player @player;
    private bool loadedPlayer = false;
}
Window @window;

}