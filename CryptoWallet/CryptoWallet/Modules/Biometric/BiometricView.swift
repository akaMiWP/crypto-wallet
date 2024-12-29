// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct BiometricView: View {
    @EnvironmentObject private var theme: ThemeManager
    @ObservedObject private var viewModel: BiometricViewModel
    private var navigationPath: Binding<NavigationPath>
    
    enum Destinations {
        case dashboard
    }
    
    init(viewModel: BiometricViewModel, navigationPath: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self.navigationPath = navigationPath
    }
    
    var body: some View {
        NavigationStack(path: navigationPath) {
            VStack {
                Image(mascotImage)
                    .resizable()
                    .frame(width: mascotSize, height: mascotSize)
                    .padding(.bottom, 24)
                
                if viewModel.allowPasswordInput {
                    VStack(spacing: 12) {
                        Text("Enter your password")
                            .font(.headline)
                            .foregroundColor(primaryForegroundColor)
                        
                        SecureField("Password", text: $viewModel.passwordInput)
                            .padding()
                            .background(placeholderBackgroundColor)
                        
                        Button(action: { viewModel.tap.send() }) {
                            Text("Unlock")
                                .font(.subheadline)
                                .foregroundColor(.neutral_20)
                                .padding(.vertical)
                                .frame(maxWidth: screenWidth)
                                .background(buttonBackgroundColor)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: screenWidth, maxHeight: screenHeight)
            .background(backgroundColor)
            .onChange(of: viewModel.isPolicyEvaluated) { newValue in
                if newValue {
                    navigationPath.wrappedValue.append(Destinations.dashboard)
                }
            }
            .onAppear { viewModel.authenticate() }
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
    BiometricView(
        viewModel: .init(authenticateUseCase: AuthenticateImp()),
        navigationPath: .constant(.init())
    )
        .environmentObject(ThemeManager())
}
