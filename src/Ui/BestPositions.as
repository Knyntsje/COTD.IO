namespace UI {

void BestPositions(const Api::BestPositions @bestPositions) {
    if (bestPositions !is null && UI::Plot::BeginPlot("Best positions", vec2(-1, 0), UI::Plot::PlotFlags::NoInputs | UI::Plot::PlotFlags::NoLegend)) {
        UI::Plot::SetupAxes("Month", "", UI::Plot::AxisFlags::NoTickMarks, UI::Plot::AxisFlags::AutoFit | UI::Plot::AxisFlags::NoTickMarks);
        UI::Plot::SetupAxisLimits(UI::Plot::Axis::X1, bestPositions.MinPosition - 0.5, bestPositions.MaxPosition + 0.5, UI::Plot::Cond::Always);
        UI::Plot::PlotBars("Best Positions", bestPositions.Amounts, 0.67, 1.0);
        UI::Plot::EndPlot();
    }
}

}