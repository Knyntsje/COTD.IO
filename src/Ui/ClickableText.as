namespace UI {

bool ClickableText(const string &in text) {
    UI::Text(text);
    if (UI::IsItemHovered()) {
        UI::SetMouseCursor(UI::MouseCursor::Hand);
    }

    return UI::IsItemClicked();
}

}