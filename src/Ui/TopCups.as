namespace UI {

bool TopCups(const array<Api::TopCup@> &in topCups) {
    bool viewAll = false;
    if (UI::BeginChild("##topCups", vec2(-1, 300.f), UI::ChildFlags::FrameStyle)) {
        UI::Text("Most played cups");

        UI::SameLine();
        UI::SetCursorPosX(UI::GetCursorPos().x + Math::Max(0.f, UI::GetContentRegionAvail().x - Draw::MeasureString("View all").x));
        if (UI::TextLink("View all")) {
            viewAll = true;
        }

        for (int i = 0; i < Math::Min(7, topCups.Length); ++i) {
            UI::NextColumn();

            const Api::TopCup @topCup = topCups[i];
            if (UI::ClickableText(topCup.Map.GetDisplayName() + "\n\\$z\\$aaa" + Api::CupTypeToDisplayString(topCup.Type) + " - " + Time::FormatStringUTC("%x", topCup.StartTs))) {
                UI::window.Router.Goto("tracks", Route::Cup(Api::Totd(topCup), topCup.Type));
            }
            
            UI::SameLine();

            const string quantityString = tostring(topCup.NumPlayers);
            UI::SetCursorPosX(UI::GetCursorPos().x + Math::Max(0.f, UI::GetContentRegionAvail().x - Draw::MeasureString(quantityString).x));
            UI::Text(quantityString);
        }
    }
    UI::EndChild();
    return viewAll;
}

}