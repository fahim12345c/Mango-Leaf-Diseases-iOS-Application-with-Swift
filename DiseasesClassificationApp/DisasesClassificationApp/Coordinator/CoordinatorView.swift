//
//  CoordinatorView.swift
//  DisasesClassificationApp
//
//  Created by fahim on 4/5/26.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @State private var isLoggedIn = AuthManager.shared.isLoggedIn
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group{
                if isLoggedIn {
                    
                }
                else{
                    coordinator.build(page: .loginView(viewModel: LoginViewModel(authManager: FirebaseAuthManager())))
                }
            }
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
        }
        .environmentObject(coordinator)

        
    }
    
}

#Preview {
    CoordinatorView()
}
