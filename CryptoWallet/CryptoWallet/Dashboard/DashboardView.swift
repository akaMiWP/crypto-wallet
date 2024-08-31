// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    var body: some View {
        makeTopBarView()
        
        ScrollView {
            Text("$21.10")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            makeOperationViews()
            
            makeERC20TokensListView()
            
            Spacer()
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
    
    func makeERC20TokensListView() -> some View {
        ForEach(0..<12) { _ in
            makeERC20TokenView()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        .padding(.horizontal)
    }
    
    func makeERC20TokenView() -> some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Token Name")
                    .font(.headline)
                
                Text("0.123456 ETH")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text("$1234")
                .font(.headline)
        }
    }
}

#Preview {
    DashboardView()
}
