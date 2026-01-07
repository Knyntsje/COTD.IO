namespace Api {

class Position {
    Position(const int _position = 0) {
        position = _position;
    }

    int GetDivision() const {
        return position / 64 + 1;
    }

    int Get() const {
        return position;
    }

    private int position;
}

}