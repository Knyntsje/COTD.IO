const int AVATAR_CACHE_WORKERS = 2;

void Main() {
	for (int i = 0; i < AVATAR_CACHE_WORKERS; i++) {
		startnew(Api::AvatarCache::Worker);
	}

	@Api::client = Api::Client();
	@UI::window = UI::Window();
	startnew(Update);
}

void Update() {
	while (true) {
		UI::window.Update();
		sleep(10);
	}
}

void RenderInterface() {
	Api::AvatarCache::BeginFrame();
	UI::window.Render();
}

void RenderMenu() {
	if (UI::MenuItem(Icons::Trophy + " COTD.IO", "", UI::window.GetIsOpen())) {
		UI::window.Toggle();
	}
}