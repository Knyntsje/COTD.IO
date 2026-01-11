namespace UI {

void MedianPositions(const Api::MedianPositions @medianPositions) {
    if (medianPositions !is null && UI::Plot::BeginPlot("Median positions", vec2(-1, 0), UI::Plot::PlotFlags::NoInputs)) {
        UI::Plot::SetupAxes("Month", "", UI::Plot::AxisFlags::NoTickMarks, UI::Plot::AxisFlags::AutoFit | UI::Plot::AxisFlags::NoTickMarks);
        UI::Plot::SetupAxisLimits(UI::Plot::Axis::X1, 0.5, 12.5, UI::Plot::Cond::Always);
        UI::Plot::PlotBars("2025", medianPositions.LastYear, 0.35, 0.825);
        UI::Plot::PlotBars("2026", medianPositions.ThisYear, 0.35, 1.175);            
        UI::Plot::EndPlot();
    }
}

}