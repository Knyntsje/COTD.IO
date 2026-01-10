namespace UI {

class ColumnRenderer {
    ColumnRenderer(const float _columnWidth, const int _maxColumns = 4) {
        this.columnWidth = _columnWidth;
        this.maxColumns = _maxColumns;
    }

    bool Begin() {
        numColumns = Math::Clamp(int(UI::GetContentRegionAvail().x / columnWidth), 1, maxColumns);
        UI::Columns(numColumns, "", false);
        return true;
    }

    void Render() {
        UI::NextColumn();
    }

    void End() {
        UI::Columns(1);
    }

    private int numColumns = 0;
    private int maxColumns;

    private float columnWidth;
}

}