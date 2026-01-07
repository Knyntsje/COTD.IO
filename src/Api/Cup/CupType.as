namespace Api {

enum e_CupType {
    Day,
    Night,
    Morning,
}

string CupTypeToDisplayString(const e_CupType &in cupType) {
    switch (cupType) {
        case e_CupType::Night:
            return "Cup of the Night";
        case e_CupType::Morning:
            return "Cup of the Morning";
    }
    return "Cup of the Day";
}

string CupTypeToString(const e_CupType &in cupType) {
    switch (cupType) {
        case e_CupType::Night:
            return "night";
        case e_CupType::Morning:
            return "morning";
    }
    return "day";
}

e_CupType CupTypeFromAbbreviation(const string &in abbreviation) {
    if (abbreviation == "COTD") {
        return e_CupType::Day;
    }
    else if (abbreviation == "COTN") {
        return e_CupType::Night;
    }
    else if (abbreviation == "COTM") {
        return e_CupType::Morning;
    }

    error("[Api::CupTypeFromAbbreviation] Invalid abbreviation: " + abbreviation);
    return e_CupType::Day;
}

}