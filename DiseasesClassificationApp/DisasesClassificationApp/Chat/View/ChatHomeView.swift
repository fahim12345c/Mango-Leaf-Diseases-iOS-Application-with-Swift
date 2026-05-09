import SwiftUI

struct ChatHomeView: View {
    private let brandGreen = Color(red: 0.18, green: 0.55, blue: 0.34)

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "message.fill")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(brandGreen)
            Text("Chat")
                .font(.title2.bold())
            Text("Connect your AI chat feature here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 30)
    }
}

#Preview {
    ChatHomeView()
}

