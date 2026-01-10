namespace UI {

class TopPlayersRenderer : ColumnRenderer {
    TopPlayersRenderer() {
        super(265.f, 4);
    }
    
    bool Render(const string &in title, const array<Api::TopPlayer@> &in topPlayers) {
        bool viewAll = false;
        if (UI::BeginChild("##topPlayers" + title, vec2(-1, 100.f))) {
            UI::Text(title);

            UI::SameLine();
            UI::SetCursorPosX(UI::GetCursorPos().x + Math::Max(0.f, UI::GetContentRegionAvail().x - Draw::MeasureString("View all").x));
            if (UI::TextLink("View all")) {
                viewAll = true;
            }

            for (int i = 0; i < Math::Min(3, topPlayers.Length); ++i) {
                UI::NextColumn();

                const Api::TopPlayer @topPlayer = topPlayers[i];
                if (topPlayer.Player.Avatar !is null) {
                    UI::Image(topPlayer.Player.Avatar, vec2(20, 20));
                    UI::SameLine();
                }
                if (UI::ClickableText(topPlayer.Player.GetDisplayName())) {
                    UI::window.Router.Goto("players", Route::Player(topPlayer.Player));
                }
                
                UI::SameLine();

                const string quantityString = tostring(topPlayer.Quantity);
                UI::SetCursorPosX(UI::GetCursorPos().x + Math::Max(0.f, UI::GetContentRegionAvail().x - Draw::MeasureString(quantityString).x));
                UI::Text(quantityString);
            }
        }
        UI::EndChild();
        ColumnRenderer::Render();
        return viewAll;
    }
}

}