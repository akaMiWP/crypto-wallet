// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct EnterPassPhraseView: View {
    @State private var maskPassword: Bool = true
    @State private var maskConfirmPassword: Bool = true
    
    @Environment(\.container) private var container
    @EnvironmentObject private var theme: ThemeManager
    @ObservedObject var viewModel: EnterPassPhraseViewModel
    private var navigationPath: Binding<NavigationPath>
    
    enum Destinations {
        case generateSeedPhrase
    }
    
    init(navigationPath: Binding<NavigationPath>,
         viewModel: EnterPassPhraseViewModel) {
        self.navigationPath = navigationPath
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            buildTopBarView()
            buildCreatePasswordView()
            buildPasswordValidationOutputView()
            buildNavigationButton()
        }
        .padding(.horizontal, 36)
        .background(backgroundColor)
        .cardStyle()
        .alertable(from: viewModel)
        .onReceive(viewModel.onSave) {
            navigationPath.wrappedValue.append(Destinations.generateSeedPhrase)
        }
        .navigationDestination(for: Destinations.self) { destination in
            switch destination {
            case .generateSeedPhrase:
                GenerateSeedPhraseView(
                    viewModel: .init(
                        manageHDWalletUseCase: ManageHDWalletImpl(),
                        manageWalletsUseCase: ManageWalletsImpl(),
                        userDefaultUseCase: UserDefaultImp(),
                        passwordRepository: container.resolve(PasswordRepository.self)
                    ),
                    navigationPath: navigationPath
                )
                .navigationBarBackButtonHidden()
            }
        }
    }
}

// MARK: - Private
private extension EnterPassPhraseView {
    var primaryForegroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var secondaryForegroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_200 : .primaryViolet1_200
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_800
    }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var shadowColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_300 : .primaryViolet1_900.opacity(0.8)
    }
    
    var paddingTop: CGFloat { screenHeight * 0.1 }
    
    @ViewBuilder
    func buildPasswordTextField(
        _ placeholder: String,
        _ text: Binding<String>,
        _ maskPassword: Binding<Bool>
    ) -> some View {
        HStack {
            if maskPassword.wrappedValue {
                SecureField(placeholder, text: text)
                    .padding()
            } else {
                TextField(placeholder, text: text)
                    .padding()
            }
            
            Button(action: { maskPassword.wrappedValue.toggle()
            }) {
                Image(maskPassword.wrappedValue ? .iconClosedEye : .iconOpenEye)
            }
            .padding()
        }
        .background(placeholderBackgroundColor)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
        .padding(.top, 6)
    }
    
    @ViewBuilder
    func buildCreatePasswordView() -> some View {
        Text("Create a password")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(primaryForegroundColor)
            .padding(.top, paddingTop)
        
        Text("Password")
            .font(.body)
            .foregroundColor(primaryForegroundColor)
            .padding(.top, 16)
        
        buildPasswordTextField("Password", $viewModel.password, $maskPassword)
        
        Text("Confirm Password")
            .font(.body)
            .foregroundColor(primaryForegroundColor)
            .padding(.top, 16)
        
        buildPasswordTextField("Confirm Password", $viewModel.confirmPassword, $maskConfirmPassword)
    }
    
    @ViewBuilder
    func buildPasswordValidationOutputView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(viewModel.validationSuccess ? .iconCheckMark : .iconCross)
                Text("Password Strength: \(viewModel.validationSuccess ? "strong" : "weak")")
            }
            HStack {
                Image(viewModel.validationPasswordLength ? .iconCheckMark : .iconCross)
                Text("At least 8 characters")
            }
            HStack {
                Image(viewModel.validationContainNumberOrSymbol ? .iconCheckMark : .iconCross)
                Text("Contains a number or symbol")
            }
        }
        .font(.caption)
        .foregroundColor(secondaryForegroundColor)
        .padding(.top, 24)
    }
    
    @ViewBuilder
    func buildTopBarView() -> some View {
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
                        .foregroundColor(primaryForegroundColor)
                        .frame(width: 24, height: 24)
                })
                
                Spacer()
            }
        }
        .padding(.top, 24)
    }
    
    @ViewBuilder
    func buildNavigationButton() -> some View {
        Spacer()
        
        PrimaryButton(title: "Continue", enabled: viewModel.validationSuccess) {
            viewModel.tap.send()
        }
            .shadow(color: shadowColor, radius: 22, x: 7, y: 7)
            .padding(.bottom, 48)
    }
}

#Preview {
    NavigationStack {
        EnterPassPhraseView(navigationPath: .constant(.init()), viewModel: .init(passwordRepository: PasswordRepositoryImp()))
            .environmentObject(ThemeManager())
    }
}
