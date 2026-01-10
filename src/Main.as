void Main() {
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
	UI::window.Render();
}

void RenderMenu() {
	if (UI::MenuItem(Icons::Trophy + " COTD.IO", "", UI::window.GetIsOpen())) {
		UI::window.Toggle();
	}
}