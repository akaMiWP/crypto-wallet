// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    var body: some View {
        makeNetworkSwitchView()
        
        Text("$21.10")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        makeOperationViews()
        
        Spacer()
    }
}

// MARK: - Private
private extension DashboardView {
    func makeNetworkSwitchView() -> some View {
        HStack {
            Text("S")
                .font(.headline)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text("Network")
                .font(.subheadline)
            
            Image(systemName: "chevron.down")
        }
        .padding(.trailing, 12)
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 32, height: 32)))
        .padding()
    }
    
    func makeOperationViews() -> some View {
        HStack(spacing: 32) {
            makeOperationView(imageName: "plus", actionName: "Receive")
            
            makeOperationView(imageName: "paperplane", actionName: "Send")
        }
        .padding()
    }
    
    func makeOperationView(imageName: String, actionName: String) -> some View {
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
    }
}

#Preview {
    DashboardView()
}
