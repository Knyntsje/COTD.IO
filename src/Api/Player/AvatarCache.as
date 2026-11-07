namespace Api::AvatarCache {

const uint MAX_ENTRIES = 128;
const uint64 FAILURE_COOLDOWN_MS = 300000;
const uint64 REQUEST_TIMEOUT_MS = 15000;

class Entry {
    string uid;
    UI::Texture @texture;
    bool loading = false;
    uint64 retryAt = 0;
    uint64 lastSeen = 0;
}

array<Entry@> cache;
uint64 frame = 0;

void BeginFrame() {
    ++frame;
}

UI::Texture @Get(const string &in uid) {
    if (uid.Length == 0) {
        return null;
    }

    int oldest = -1;
    for (uint i = 0; i < cache.Length; ++i) {
        Entry @entry = cache[i];
        if (entry.uid == uid) {
            entry.lastSeen = frame;
            return entry.texture;
        }

        if (!entry.loading && entry.lastSeen + 1 < frame && (oldest < 0 || entry.lastSeen < cache[oldest].lastSeen)) {
            oldest = int(i);
        }
    }

    if (cache.Length >= MAX_ENTRIES && oldest < 0) {
        return null;
    }

    Entry @entry = Entry();
    entry.uid = uid;
    entry.lastSeen = frame;

    if (cache.Length < MAX_ENTRIES) {
        cache.InsertLast(entry);
    }
    else {
        @cache[oldest] = entry;
    }

    return null;
}

void Worker() {
    while (true) {
        Entry @next;
        foreach (Entry @entry : cache) {
            if (entry.lastSeen == frame && entry.texture is null && !entry.loading && Time::Now >= entry.retryAt) {
                @next = entry;
                break;
            }
        }

        if (next !is null) {
            next.loading = true;
            try {
                Download(next);
            }
            catch {
                warn("[AvatarCache] Avatar load failed for " + next.uid + ": " + getExceptionInfo());
            }

            if (next.texture is null) {
                next.retryAt = Time::Now + FAILURE_COOLDOWN_MS;
            }
            next.loading = false;
        }
        sleep(25);
    }
}

void Download(Entry @entry) {
    Net::HttpRequest @request = Net::HttpRequest("https://avatars.ubisoft.com/" + entry.uid + "/default_146_146.png");
    if (dev.LogAPIRequests()) {
        print("[AvatarCache] Download: " + entry.uid);
    }
    request.Start();

    uint64 started = Time::Now;
    while (!request.Finished()) {
        if (Time::Now - started >= REQUEST_TIMEOUT_MS) {
            request.Cancel();
            while (!request.Finished()) {
                sleep(25);
            }
            return;
        }
        sleep(25);
    }

    if (request.ResponseCode() / 100 != 2 || request.Buffer().GetSize() == 0) {
        warn("[AvatarCache] Download failed for " + entry.uid + ". Code: " + request.ResponseCode() + " Error: " + request.Error());
        return;
    }

    UI::Texture @texture = UI::LoadTexture(request.Buffer());
    if (texture !is null && texture.GetSize().x <= 146 && texture.GetSize().y <= 146) {
        @entry.texture = texture;
    }
}

}