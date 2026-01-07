namespace UI {

bool CupTypeCombo(array<Api::e_CupType> &inout cupTypes) {
    string displayValue = "";

    if (cupTypes.IsEmpty()) {
        cupTypes.InsertLast(Api::e_CupType::Day);
    }

    const int dayIndex = cupTypes.Find(Api::e_CupType::Day);
    const int nightIndex = cupTypes.Find(Api::e_CupType::Night);
    const int morningIndex = cupTypes.Find(Api::e_CupType::Morning);

    if (dayIndex != -1) {
        displayValue = AppendString(displayValue, Api::CupTypeToDisplayString(Api::e_CupType::Day), ", ");
    }
    if (nightIndex != -1) {
        displayValue = AppendString(displayValue, Api::CupTypeToDisplayString(Api::e_CupType::Night), ", ");
    }
    if (morningIndex != -1) {
        displayValue = AppendString(displayValue, Api::CupTypeToDisplayString(Api::e_CupType::Morning), ", ");
    }

    bool changed = false;
    if (UI::BeginCombo("##cupType", displayValue)) {
        if (UI::Selectable(Api::CupTypeToDisplayString(Api::e_CupType::Day), dayIndex != -1, UI::SelectableFlags::NoAutoClosePopups)) {
            if (dayIndex == -1) {
                cupTypes.InsertLast(Api::e_CupType::Day);
            }
            else {
                cupTypes.RemoveAt(dayIndex);
            }
            changed = true;
        }
        if (UI::Selectable(Api::CupTypeToDisplayString(Api::e_CupType::Night), nightIndex != -1, UI::SelectableFlags::NoAutoClosePopups)) {
            if (nightIndex == -1) {
                cupTypes.InsertLast(Api::e_CupType::Night);
            }
            else {
                cupTypes.RemoveAt(nightIndex);
            }
            changed = true;
        }
        if (UI::Selectable(Api::CupTypeToDisplayString(Api::e_CupType::Morning), morningIndex != -1, UI::SelectableFlags::NoAutoClosePopups)) {
            if (morningIndex == -1) {
                cupTypes.InsertLast(Api::e_CupType::Morning);
            }
            else {
                cupTypes.RemoveAt(morningIndex);
            }
            changed = true;
        }
        UI::EndCombo();
    }
    return changed;
}

}