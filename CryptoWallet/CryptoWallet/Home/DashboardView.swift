// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            makeTopBarView()
            
            ScrollView {
                Text("$21.10")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                makeOperationViews()
                
                TokenListView()
                
                Spacer()
            }
        }
    }
}

// MARK: - Private
private extension DashboardView {
    func makeTopBarView() -> some View {
        ZStack {
            HStack {
                Text("Account 1")
                    .font(.headline)
                
                Image(systemName: "chevron.down")
            }
            
            HStack {
                HStack {
                    Text("S")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                    
                    Image(systemName: "chevron.down")
                }
                .padding(.trailing, 12)
                .background(Color.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 32, height: 32)))
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    func makeOperationViews() -> some View {
        HStack(spacing: 32) {
            makeOperationView(imageName: "plus", actionName: "Receive", destination: .receive)
            
            makeOperationView(imageName: "paperplane", actionName: "Send", destination: .sendTokens)
        }
        .padding()
    }
    
    func makeOperationView(imageName: String, actionName: String, destination: Destination) -> some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(Color.blue)
            Text(actionName)
                .font(.caption)
        }
        .frame(width: 100, height: 80)
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        .onTapGesture { isSheetPresented = true }
        .sheet(isPresented: $isSheetPresented) {
            switch destination {
            case .sendTokens: SelectTokenView()
            case .receive: SelectTokenView()
            }
        }
    }
}

#Preview {
    DashboardView()
}
