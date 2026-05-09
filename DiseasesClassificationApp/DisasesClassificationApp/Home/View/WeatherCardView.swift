//
//  WeatherCardView.swift
//  DisasesClassificationApp
//

import SwiftUI

// MARK: - WeatherCardView
struct WeatherCardView: View {
    let locationTitle: String
    let weather: WeatherDisplayModel
    let state: WeatherLoadState
    let onRefresh: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.53, green: 0.81, blue: 0.98),
                            Color(red: 0.35, green: 0.68, blue: 0.93)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .blue.opacity(0.2), radius: 12, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 0) {
                // Top row
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.9))
                        Text(locationTitle)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        if case .error = state {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                        }
                        Button(action: onRefresh) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.85))
                        }
                    }
                }
                .padding(.bottom, 14)

                // Middle row: info left, temp right
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(formattedDate())
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))

                        Text(weather.description)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)

                        Text(weather.tempRange)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.75))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        if state == .loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.3)
                                .padding(.trailing, 8)
                        } else {
                            Text(weather.temperature)
                                .font(.system(size: 46, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Image(systemName: weather.icon)
                            .font(.system(size: 36))
                            .foregroundColor(.white.opacity(0.9))
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .padding(.bottom, 14)

                Divider().background(Color.white.opacity(0.35)).padding(.bottom, 12)

                // Stats row
                HStack {
                    weatherStat(icon: "humidity.fill",  value: weather.humidity,  label: "Humidity")
                    Spacer()
                    weatherStat(icon: "wind",           value: weather.windSpeed, label: "Wind")
                    Spacer()
                    weatherStat(icon: "cloud.rain.fill", value: weather.rain,     label: "Rain")
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
    }

    private func weatherStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return f.string(from: Date())
    }
}

