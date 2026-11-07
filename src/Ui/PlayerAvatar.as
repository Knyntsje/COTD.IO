namespace UI {

void PlayerAvatar(const Api::Player @player) {
    float size = UI::GetTextLineHeight();
    if (player.Avatar is null) {
		UI::Dummy(vec2(size, size));
	}
    else {
		UI::Image(player.Avatar, vec2(size, size));
	}

    UI::SameLine();
}

}