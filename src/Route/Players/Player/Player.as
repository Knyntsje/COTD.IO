namespace Route {

class Player : SubRoute {
    Player(const Api::Player @_player) {
        super("player", _player.GetDisplayName());
        @player = _player;

        @router = Router();
        router.AddRoute(Route::PlayerCups(_player));
        router.AddRoute(Route::PlayerTotds(_player));
    }

    void Update() override {
        router.Update();
        SubRoute::Update();
    }

    protected void RenderRoute() override {
        router.Render();
    }

    protected void Reset() override {
        router.Reset();
    }

    protected void Load() override {}

    private const Api::Player @player;
    private Router @router;
}

}