namespace Api {

enum e_Medal {
    None = 0,
    Bronze = 1,
    Silver = 2,
    Gold = 3,
    Author = 4,
}

string MedalToColor(const e_Medal &in medal) {
    switch (medal) {
        case e_Medal::Bronze:
            return "\\$f80";
        case e_Medal::Silver:
            return "\\$ccc";
        case e_Medal::Gold:
            return "\\$fd0";
        case e_Medal::Author:
            return "\\$0b0";
    }

    return "\\$fff";
}

}