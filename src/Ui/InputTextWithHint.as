namespace UI {

string InputTextWithHint(const string &in label, const string &in hint, const string &in str, bool &out changed, int flags = UI::InputTextFlags::None, UI::InputTextCallback @callback = null) {
    const vec2 cursorPos = UI::GetCursorPos();
    const string newStr = UI::InputText(label, str, changed, flags, callback);
    const vec2 newCursorPos = UI::GetCursorPos();

    if (newStr.Length == 0 && !UI::IsItemActive()) {
        UI::SetCursorPos(cursorPos + vec2(8, 4));
        UI::Text("\\$999" + hint);
    }

    UI::SetCursorPos(newCursorPos);
    return newStr;
}

}