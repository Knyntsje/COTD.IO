string AppendString(string &in str, const string &in append, const string &in separator = "") {
    if (append.Length == 0) {
        return str;
    }

    if (str.Length > 0) {
        str += separator;
    }
    str += append;
    return str;
}