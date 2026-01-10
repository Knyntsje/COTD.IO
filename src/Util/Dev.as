class Dev {
    bool UseLocalAPI() {
        return isDevBuild && Settings::Dev::USE_LOCAL_API;
    }

    bool LogAPIRequests() {
        return isDevBuild && Settings::Dev::LOG_API_REQUESTS;
    }

    private bool isDevBuild = Meta::ExecutingPlugin().Version == "dev";
}
Dev dev;