//
//  MainTabView.swift
//  DisasesClassificationApp
//
//  Created by fahim on 6/5/26.
//
//
//  MainTabView.swift
//  AgriAI Dashboard
//

import SwiftUI

// MARK: - Tab
enum AppTab: Int, CaseIterable {
    case home
    case weather
    case diseases
    case profile

    var title: String {
        switch self {
        case .home:     return "Home"
        case .weather:  return "Weather"
        case .diseases: return "Diseases"
        case .profile:  return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home:     return "house.fill"
        case .weather:  return "cloud.sun.fill"
        case .diseases: return "camera.fill"
        case .profile:  return "person.fill"
        }
    }
}

// MARK: - MainTabView
struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    // Pass from your coordinator / auth flow
    var userName: String = "Farmer"

    // Coordinator callbacks
    var onDiseaseScannerTap: (() -> Void)? = nil
    var onCommunityTap: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            TabView(selection: $selectedTab) {
                HomeView(
                    userName: userName,
                    onDiseaseScannerTap: { selectedTab = .diseases },
                    onCommunityTap: onCommunityTap, onWeatherTap: { selectedTab = .weather },
                    onProfileTap: { selectedTab = .profile }
                )
                .tag(AppTab.home)

                WeatherFullView()
                    .tag(AppTab.weather)

                DiseasesScannerView()
                    .tag(AppTab.diseases)

                ProfileView(userName: userName)
                    .tag(AppTab.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar
            customTabBar
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Spacer()
                tabBarItem(tab: tab)
                Spacer()
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: -4)
        )
    }

    private func tabBarItem(tab: AppTab) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("agriGreen").opacity(0.15))
                            .frame(width: 48, height: 32)
                    }
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: selectedTab == tab ? .bold : .regular))
                        .foregroundColor(selectedTab == tab ? Color("agriGreen") : Color.gray.opacity(0.6))
                }
                Text(tab.title)
                    .font(.system(size: 11, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundColor(selectedTab == tab ? Color("agriGreen") : Color.gray.opacity(0.6))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
    }
}

// MARK: - Placeholder tab screens (replace with your real views)

struct WeatherFullView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Weather Detail")
                    .font(.title)
                    .foregroundColor(Color("agriGreen"))
            }
            .navigationTitle("Weather")
        }
    }
}

struct DiseasesScannerView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 64))
                    .foregroundColor(Color("agriGreen"))
                Text("Disease Scanner")
                    .font(.title2.bold())
                Text("Integrate your mango leaf classification model here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .navigationTitle("Diseases")
        }
    }
}

struct ProfileView: View {
    var userName: String
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Circle()
                    .fill(Color("agriGreen").opacity(0.15))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color("agriGreen"))
                    )
                Text(userName)
                    .font(.title3.bold())
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView(userName: "fahimalislam1919")
}
