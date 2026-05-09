import SwiftUI

// MARK: - WeatherFeatureView (Redesigned — all UI issues fixed)
struct WeatherFeatureView: View {
    @StateObject private var vm = WeatherFeatureViewModel()

    private let brandGreen = Color(red: 0.18, green: 0.55, blue: 0.34)
    @State private var isLegendPresented = false

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    currentWeatherCard
                        .padding(.top, 14)
                    modeTabs
                    if vm.mode == .spraying {
                        sprayingContent
                    } else {
                        detailsContent
                    }
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear { vm.onAppear() }
        .sheet(isPresented: $isLegendPresented) {
            WeatherLegendSheetView()
                .presentationDetents([.large])
        }
    }

    // MARK: - Header Bar
    // FIXED: Replaced ZStack double-fill that was causing the huge empty green space.
    //        Now a single HStack with .ignoresSafeArea(edges: .top) on the background.
    //        The "Search" pill that was wrapping into "Searc h" is replaced with
    //        a compact icon button.
    private var headerBar: some View {
        HStack(spacing: 10) {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .accessibilityLabel("Menu")

            Text("Weather")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            // FIXED: was a text pill "Search" that wrapped; now an icon button
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(.white.opacity(0.18)))
            }
            .accessibilityLabel("Search")

            Button(action: { vm.refresh() }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(.white.opacity(0.18)))
            }
            .accessibilityLabel("Refresh")

            Button(action: { isLegendPresented = true }) {
                Image(systemName: "questionmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(.white.opacity(0.18)))
            }
            .accessibilityLabel("Help")
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)     // tight — safe area handled by background
        .padding(.bottom, 12)
        .background(brandGreen.ignoresSafeArea(edges: .top))
    }

    // MARK: - Current Weather Card
    // FIXED: Combined main info + quick stats into one card to match the
    //        screenshot design. Stats row (Humidity / Wind / Rain) is now
    //        inside the card, not floating separately.
    private var currentWeatherCard: some View {
        VStack(spacing: 0) {

            // — Main info row —
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.blue.opacity(0.12))
                    Image(systemName: vm.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.blue)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 3) {
                    Text(vm.locationTitle)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(vm.temperatureText)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        Text(vm.conditionText)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }

                    Text(vm.descriptionText)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            .padding(16)

            // — Thin separator —
            Rectangle()
                .fill(Color(.separator).opacity(0.5))
                .frame(height: 0.5)
                .padding(.horizontal, 16)

            // — Quick stats row: Humidity | Wind | Rain —
            // FIXED: Used frame(maxWidth:.infinity) so columns are always equal
            HStack(spacing: 0) {
                quickStat(icon: "humidity.fill",   value: vm.humidityText, label: "Humidity", tint: .blue)
                Divider().frame(height: 36)
                quickStat(icon: "wind",            value: vm.windText,     label: "Wind",     tint: .teal)
                Divider().frame(height: 36)
                quickStat(icon: "cloud.rain.fill", value: vm.rainText,     label: "Rain",     tint: .indigo)
            }
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func quickStat(icon: String, value: String, label: String, tint: Color) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Mode Tabs
    private var modeTabs: some View {
        Picker("", selection: $vm.mode) {
            ForEach(WeatherFeatureViewModel.Mode.allCases) { mode in
                Label(
                    mode.rawValue,
                    systemImage: mode == .spraying ? "drop.fill" : "list.bullet.rectangle"
                )
                .tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Spraying Content
    private var sprayingContent: some View {
        VStack(spacing: 14) {
            applicationTypeCard
            sprayingWindowCard
            smartAdviceCard
        }
    }

    // FIXED: Each button now uses VStack so the label never truncates.
    //        The selected-state indicator is a visible checkmark.circle.fill.
    private var applicationTypeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Application Type", systemImage: "drop.halffull")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ForEach(ApplicationType.allCases) { t in
                    Button { vm.application = t } label: {
                        VStack(spacing: 6) {
                            Image(systemName: vm.application == t ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(vm.application == t ? Color.blue : Color.secondary.opacity(0.4))
                            Text(t.rawValue)
                                .font(.system(size: 13, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(vm.application == t ? Color.blue : Color.primary)
                                // FIXED: fixedSize prevents text from being squashed
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(vm.application == t
                                      ? Color.blue.opacity(0.10)
                                      : Color(.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(
                                            vm.application == t ? Color.blue.opacity(0.35) : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.15), value: vm.application)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }

    private var sprayingWindowCard: some View {
        let status = vm.assessment.status
        return VStack(spacing: 0) {

            // — Status banner —
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current Window")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .kerning(0.5)
                    Text(status.rawValue)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(statusColor(status))
                }
                Spacer()
                Image(systemName: statusIcon(status))
                    .font(.system(size: 36))
                    .foregroundStyle(statusColor(status).opacity(0.85))
            }
            .padding(18)
            .background(statusBackground(status))

            // — Delta T / Wind metrics —
            HStack(spacing: 0) {
                sprayMetric(label: "Delta T",   value: "\(vm.assessment.deltaT.round1)°C",      color: .orange)
                Divider().frame(height: 40)
                sprayMetric(label: "Wind Speed", value: "\(vm.assessment.windKmh.round1) km/h", color: .teal)
            }
            .padding(.vertical, 14)
            .background(Color(.systemBackground))

            Rectangle()
                .fill(Color(.separator).opacity(0.4))
                .frame(height: 0.5)

            // — Summary lines —
            VStack(alignment: .leading, spacing: 10) {
                ForEach(vm.assessment.summaryLines) { line in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: symbol(for: line.level))
                            .foregroundStyle(color(for: line.level))
                            .frame(width: 18)
                        Text(line.text)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            // FIXED: prevent clipping on narrower screens
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 5)
    }

    private func sprayMetric(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }

    private var smartAdviceCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.orange)
                Text("Smart Advice")
                    .font(.system(size: 16, weight: .bold))
            }

            Text(vm.assessment.adviceTitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(vm.assessment.adviceBody)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
        )
    }

    // MARK: - Details Content
    // FIXED: Section header color changed to use primary instead of blue.opacity(0.85)
    //        which was too subtle. Added icon for visual interest.
    //        DetailTile values use minimumScaleFactor so long strings never clip.
    private var detailsContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Current Conditions", icon: "thermometer.sun.fill")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                DetailTile(title: "Feels Like", value: vm.feelsLikeText, icon: "thermometer",   tint: .blue)
                DetailTile(title: "Humidity",   value: vm.humidityText,  icon: "humidity.fill", tint: .blue)
                DetailTile(title: "Wind",       value: vm.windText,      icon: "wind",          tint: .teal)
                DetailTile(title: "Pressure",   value: vm.pressureText,  icon: "gauge",         tint: .indigo)
            }

            sectionHeader("Precipitation", icon: "cloud.rain.fill")
                .padding(.top, 4)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                DetailTile(title: "Rain (1h)", value: vm.rainText,   icon: "cloud.rain.fill", tint: .blue)
                DetailTile(title: "Clouds",    value: vm.cloudsText, icon: "cloud.fill",      tint: .gray)
            }
        }
        .padding(.top, 2)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(brandGreen)
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Shared Helpers
    private func statusColor(_ status: SprayingWindowStatus) -> Color {
        switch status {
        case .optimal: return .green
        case .marginal: return .orange
        case .poor:    return .red
        }
    }

    private func statusBackground(_ status: SprayingWindowStatus) -> some View {
        let colors: [Color] = {
            switch status {
            case .optimal: return [Color.green.opacity(0.22),  Color.green.opacity(0.10)]
            case .marginal: return [Color.orange.opacity(0.22), Color.orange.opacity(0.10)]
            case .poor:    return [Color.red.opacity(0.18),    Color.red.opacity(0.08)]
            }
        }()
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func statusIcon(_ status: SprayingWindowStatus) -> String {
        switch status {
        case .optimal: return "checkmark.seal.fill"
        case .marginal: return "exclamationmark.triangle.fill"
        case .poor:    return "xmark.octagon.fill"
        }
    }

    private func symbol(for level: SprayingSummaryLine.Level) -> String {
        switch level {
        case .good: return "checkmark.circle.fill"
        case .bad:  return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    private func color(for level: SprayingSummaryLine.Level) -> Color {
        switch level {
        case .good: return .green
        case .bad:  return .red
        case .info: return .blue
        }
    }
}

// MARK: - Double extension
private extension Double {
    var round1: String { String(format: "%.1f", self) }
}

// MARK: - DetailTile
// FIXED: Value text now uses minimumScaleFactor so long readings never clip.
//        Icon background is consistent size on all tile types.
private struct DetailTile: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint.opacity(0.12))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(tint)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    // FIXED: was 0.85 which could still clip; 0.7 gives more room
                    .minimumScaleFactor(0.70)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    WeatherFeatureView()
}
