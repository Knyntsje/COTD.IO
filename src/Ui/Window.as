namespace UI {

class Window {
    Window() {
        @router = Route::Router();
        // router.AddRoute(Route::Stats()); -- Soon :)
        router.AddRoute(Route::Tracks());
        router.AddRoute(Route::Players());

        if (Meta::ExecutingPlugin().Version == "dev") {
            isOpen = true;
        }
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

        int flags = UI::WindowFlags::NoCollapse;
        if (player !is null) {
            flags |= UI::WindowFlags::MenuBar;
        }

        if (UI::Begin(Icons::Trophy + " COTD.IO", isOpen, flags)) {
            if (player !is null && UI::BeginMenuBar()) {
                if (UI::MenuItem(player.GetDisplayName())) {
                    router.Goto("players", Route::Player(player));
                }
                UI::EndMenuBar();
            }

            router.Render();
            UI::End();
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

    private bool isOpen = false;
    private Route::Router @router;

    private Api::Player @player;
    private bool loadedPlayer = false;
}
Window window;

}