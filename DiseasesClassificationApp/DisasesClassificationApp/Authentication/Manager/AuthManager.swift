//
//  AuthService.swift
//  DisasesClassificationApp
//
//  Created by fahim on 4/5/26.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
        
        private let isLoggedInKey = "isLoggedIn"
        
        @Published var isLoggedIn: Bool {
            didSet {
                UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
            }
        }
        
        private init() {
            self.isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        }
        
        // Simulated register
        func register(email: String, password: String) async throws -> Bool {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            return true
        }

}
 
// MARK: - AuthError
enum AuthError: LocalizedError {
    case emailAlreadyInUse
    case networkError
    case unknown
 
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse: return "This email address is already registered."
        case .networkError:      return "A network error occurred. Please try again."
        case .unknown:           return "Something went wrong. Please try again."
        }
    }
}
