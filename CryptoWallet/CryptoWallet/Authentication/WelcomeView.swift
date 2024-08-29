// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .padding()
                
                Spacer()
                
                Button("Create a seed phrase", action: { return })
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                
                Button("Import a seed phrase", action: { return })
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
            }
        }
        .navigationTitle("Welcome !")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
