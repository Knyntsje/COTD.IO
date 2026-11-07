namespace Route {

const uint MAX_HISTORY_ENTRIES = 100;

class NavigationState {
    bool Matches(NavigationState @other) {
        if (other is null || route !is other.route || (subRoute is null) != (other.subRoute is null) || (tab is null) != (other.tab is null)) {
            return false;
        }

        return (subRoute is null || subRoute.Matches(other.subRoute)) && (tab is null || tab.Matches(other.tab));
    }

	Route @route;
    NavigationState @subRoute;
    NavigationState @tab;
}

class NavigationHistory {
    void Record(NavigationState @state) {
        if (state is null || (position >= 0 && entries[position].Matches(state))) {
            return;
        }

        while (int(entries.Length) > position + 1) {
            entries.RemoveLast();
        }
        entries.InsertLast(state);

        if (entries.Length > MAX_HISTORY_ENTRIES) {
            entries.RemoveAt(0);
        }
        position = int(entries.Length) - 1;
    }

    void Navigate(Router @router, int direction) {
        const int next = position + direction;
        if (next < 0 || next >= int(entries.Length)) {
            return;
        }

        position = next;
        router.RestoreNavigation(entries[position]);
    }

    private array<NavigationState@> entries;
    private int position = -1;
}

}