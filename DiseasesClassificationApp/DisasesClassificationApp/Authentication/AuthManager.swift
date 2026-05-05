//
//  AuthService.swift
//  DisasesClassificationApp
//
//  Created by fahim on 4/5/26.
//

import Foundation

actor AuthManager {
    static let shared = AuthManager()
    private let isLoggedInKey = "isLoggedIn"
    private init() {}
 
    func register(email: String, password: String) async throws -> Bool {
        // Simulate network request
        try await Task.sleep(nanoseconds: 1_500_000_000)
 
        // Example: throw if email already taken
        // throw AuthError.emailAlreadyInUse
 
        return true
    }
    @MainActor
    var isLoggedIn: Bool {
            get {
                UserDefaults.standard.bool(forKey: isLoggedInKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
            }
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
