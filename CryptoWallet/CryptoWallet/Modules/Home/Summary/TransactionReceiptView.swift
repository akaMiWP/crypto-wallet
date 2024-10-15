// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

enum ReceiptViewState: Equatable {
    case initiatingTransaction
    case processingTransaction
    case confirmedTransaction(txHash: String)
}

struct TransactionReceiptView: View {
    
    @Binding var viewState: ReceiptViewState
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            buildDetailRows()
                .animation(.easeIn, value: viewState)
        }
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
    
    func buildDetailRows() -> some View {
        switch viewState {
        case .initiatingTransaction:
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
                
                buildDetailRow(isLoading: true, title: "Initiate Transaction")
                buildDetailRow(isLoading: true, title: "Processing Transaction")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color.secondaryGreen1_100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        case .processingTransaction:
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
        case .confirmedTransaction(let txHash):
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
                buildDetailRow(isLoading: false, title: "Processing Transaction", subtitle: "\(txHash)")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color.secondaryGreen1_100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
    }
}

#Preview {
    TransactionReceiptView(viewState: .constant(.initiatingTransaction))
}
