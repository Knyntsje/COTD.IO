namespace UI {

funcdef void InfiniteScrollCallback();

class InfiniteScroll {
    InfiniteScroll(InfiniteScrollCallback@ callback, float threshold = 1.f) {
        @onLoadMore = callback;
        triggerThreshold = threshold;
    }
    
    void CheckScroll() {
        if (!hasMore || isLoading || onLoadMore is null) {
            return;
        }

        if (UI::GetScrollY() >= UI::GetScrollMaxY() * triggerThreshold) {
            isLoading = true;
            onLoadMore();
        }
    }
    
    void SetLoadingComplete(bool moreDataAvailable = true) {
        isLoading = false;
        hasMore = moreDataAvailable;
    }
    
    void Reset() {
        isLoading = false;
        hasMore = true;
    }

    private InfiniteScrollCallback @onLoadMore = null;
    private float triggerThreshold = 1.f;
    protected bool isLoading = false;
    private bool hasMore = true;
}

class InfiniteScrollTable : InfiniteScroll { 
    InfiniteScrollTable(const string &in name, InfiniteScrollCallback @callback, float threshold = 1.f) {
        super(callback, threshold);
        tableName = name;
    }

    bool Begin(int columnCount, UI::TableFlags flags = UI::TableFlags::SizingStretchProp) {
        return UI::BeginTable(tableName, columnCount, flags | UI::TableFlags::ScrollY);
    }
    
    void End() {
        CheckScroll();

        if (isLoading) {
            if (UI::TableNextColumn()) {
                UI::Text("\\$999" + Icons::Spinner + " Loading...");
            }
        }

        UI::EndTable();
    }

    private string tableName;
}

class InfiniteScrollList : InfiniteScroll {
    InfiniteScrollList(const string &in name, InfiniteScrollCallback @callback, float threshold = 1.f) {
        super(callback, threshold);
        listName = name;
    }
    
    bool Begin() {
        return UI::BeginListBox(listName);
    }
    
    void End() {
        CheckScroll();
        UI::EndListBox();
    }

    private string listName;
}

}