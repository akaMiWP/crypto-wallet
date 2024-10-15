// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TransactionReceiptView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Transaction Pending")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.secondaryGreen1_900)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .foregroundColor(Color.secondaryGreen1_900)
            }
            .padding(.horizontal, 24)
            
            buildDetailRow(isLoading: false, title: "Initiate Transaction")
            buildDetailRow(isLoading: true, title: "Processing Transaction", subtitle: "This may take a few minutes")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Color.secondaryGreen1_100)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}

private extension TransactionReceiptView {
    func buildDetailRow(
        isLoading: Bool,
        title: String,
        subtitle: String? = nil
    ) -> some View {
        HStack(spacing: 16) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(Color.secondaryGreen1_800)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color.secondaryGreen1_900)
                    .fontWeight(.semibold)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(Color.secondaryGreen1_800)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical)
    }
}

#Preview {
    TransactionReceiptView()
}
