// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct BiometricView: View {
    @StateObject private var viewModel: BiometricViewModel = .init()
    @Binding var navigationPath: NavigationPath
    
    @State private var passwordInput: String = ""
    @EnvironmentObject private var theme: ThemeManager
    
    enum Destinations {
        case dashboard
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                
                Spacer()
                
                Image(mascotImage)
                    .resizable()
                    .frame(width: mascotSize, height: mascotSize)
                    .padding(.bottom, 24)
                
                Text("Enter your password")
                    .font(.headline)
                    .foregroundColor(primaryForegroundColor)
                
                SecureField("Password", text: $passwordInput)
                    .padding()
                    .background(placeholderBackgroundColor)
                
                Spacer()
                Button(action: {}) {
                    Text("Unlock")
                        .font(.subheadline)
                        .foregroundColor(.neutral_20)
                        .padding(.vertical)
                        .frame(maxWidth: screenWidth)
                        .background(buttonBackgroundColor)
                }
            }
            .padding()
            .frame(maxWidth: screenWidth, maxHeight: screenHeight)
            .background(backgroundColor)
            .onChange(of: viewModel.isPolicyEvaluated) { newValue in
                if newValue {
                    navigationPath.append(Destinations.dashboard)
                }
            }
//            .onAppear { viewModel.authenticate() }
            .navigationDestination(for: Destinations.self) {
                switch $0 {
                case .dashboard:
                    TabbarView(viewModel: .init())
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

// MARK: - Private
private extension BiometricView {
    
    var primaryForegroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_800
    }
    
    var buttonBackgroundColor: Color { .primaryViolet1_500 }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var mascotImage: ImageResource {
        theme.currentTheme == .light ? .mascotLight : .mascotDark
    }
    
    var mascotSize: CGFloat { screenWidth * 0.6 }
}

#Preview {
    BiometricView(navigationPath: .constant(.init()))
        .environmentObject(ThemeManager())
}
