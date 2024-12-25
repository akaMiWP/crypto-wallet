// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct EnterPassPhraseView: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject private var theme: ThemeManager
    
    private var navigationPath: Binding<NavigationPath>
    private let viewModel: EnterPassPhraseViewModel
    
    init(navigationPath: Binding<NavigationPath>,
         viewModel: EnterPassPhraseViewModel) {
        self.navigationPath = navigationPath
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                ProgressBarView(totalSteps: 3, currentIndex: 0)
            }
            .frame(maxWidth: .infinity)
            .overlay {
                HStack {
                    Button(action: {
                        navigationPath.wrappedValue.removeLast()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(foregroundColor)
                            .frame(width: 24, height: 24)
                    })
                    
                    Spacer()
                }
            }
            .padding(.top, 24)
            
            Text("Create a password")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
                .padding(.top, paddingTop)
            
            Text("Password")
                .font(.body)
                .foregroundColor(foregroundColor)
                .padding(.top, 16)
            
            TextField("Password", text: $password)
                .padding()
                .background(placeholderBackgroundColor)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
                .padding(.top, 6)
            
            Text("Confirm Password")
                .font(.body)
                .foregroundColor(foregroundColor)
                .padding(.top, 16)
            
            TextField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(placeholderBackgroundColor)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Password Strength")
                }
                HStack {
                    Text("At least 8 characters")
                }
                HStack {
                    Text("Contains a number or symbol")
                }
            }
            .font(.caption)
            .foregroundColor(foregroundColor)
            .padding(.top, 24)
            
            Spacer()
            
            PrimaryButton(title: "Continue") {}
            .shadow(color: shadowColor, radius: 22, x: 7, y: 7)
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 36)
        .background(backgroundColor)
        .cardStyle()
    }
}

// MARK: - Private
private extension EnterPassPhraseView {
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_800
    }
    
    var buttonBackgroundColor: Color { .primaryViolet1_500 }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var shadowColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_300 : .primaryViolet1_900.opacity(0.8)
    }
    
    var paddingTop: CGFloat { screenHeight * 0.15 }
}

#Preview {
    NavigationStack {
        EnterPassPhraseView(navigationPath: .constant(.init()), viewModel: .init())
            .environmentObject(ThemeManager())
    }
}
