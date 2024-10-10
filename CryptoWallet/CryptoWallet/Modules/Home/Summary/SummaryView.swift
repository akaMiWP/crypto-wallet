// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: SummaryViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let viewModel: SummaryViewModel = .init()
    return SummaryView(viewModel: viewModel)
}
