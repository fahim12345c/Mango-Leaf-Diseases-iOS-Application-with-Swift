import SwiftUI

struct WeatherLegendSheetView: View {
    private let brandGreen = Color(red: 0.18, green: 0.55, blue: 0.34)

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    LegendCard(
                        title: "ET",
                        descriptionText: "Water lost through evaporation and plant transpiration.",
                        tip: "Used to calculate the exact irrigation volume needed to replace water lost by crops.",
                        tint: .orange
                    )
                    LegendCard(
                        title: "GDD",
                        descriptionText: "Heat accumulation used to predict plant growth.",
                        tip: "Predicts crop maturity stages and the optimal timing for pest control.",
                        tint: .green
                    )
                    LegendCard(
                        title: "UV Index",
                        descriptionText: "Intensity of ultraviolet radiation.",
                        tip: "High UV degrades biological pesticides and certain light-sensitive chemicals quickly.",
                        tint: .red
                    )
                    LegendCard(
                        title: "Delta T (ΔT)",
                        descriptionText: "Difference between dry and wet bulb temperature.",
                        tip: "Optimal: 2 to 8. >8 means fast evaporation. <2 means runoff risk.",
                        tint: .blue
                    )
                    LegendCard(
                        title: "Wind",
                        descriptionText: "Speed of air movement.",
                        tip: "Ideal for spraying: 3-15 km/h. >15 causes drift. <3 risks temperature inversions.",
                        tint: .teal
                    )
                    LegendCard(
                        title: "Leaf Wetness",
                        descriptionText: "Presence of liquid water on crop foliage.",
                        tip: "Prolonged wetness increases fungal disease risk (blight, mildew).",
                        tint: .indigo
                    )
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
        }
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "book.fill")
                .foregroundStyle(.white)
            Text("Weather Legend")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(brandGreen)
    }
}

private struct LegendCard: View {
    let title: String
    let descriptionText: String
    let tip: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(tint.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "drop.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(tint)
                    )
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(tint)
                Spacer()
            }

            Text(descriptionText)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb")
                    .foregroundStyle(.orange)
                Text(tip)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.orange.opacity(0.10))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(tint.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

#Preview {
    WeatherLegendSheetView()
}

