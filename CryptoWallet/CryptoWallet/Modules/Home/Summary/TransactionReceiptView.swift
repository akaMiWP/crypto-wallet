// Copyright © 2567 BE akaMiWP. All rights reserved.

import SafariServices
import SwiftUI

struct TransactionReceiptView: View {
    
    @ObservedObject var viewModel: TransactionReceiptViewModel
    @State var shouldPresentSafariView: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            buildDetailRows()
                .animation(.easeIn, value: viewModel.viewState)
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
                
                if let subtitle = subtitle, let url = viewModel.buildURL()  {
                    HStack {
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundColor(Color.secondaryGreen1_800)
                            .lineLimit(1)
                        
                        Button(action: {
                            shouldPresentSafariView = true
                        }, label: {
                            Image(systemName: "link")
                                .fontWeight(.bold)
                                .foregroundColor(Color.secondaryGreen1_800)
                        })
                    }
                    .sheet(isPresented: $shouldPresentSafariView) {
                        SafariView(url: url)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical)
    }
    
    func buildDetailRows() -> some View {
        switch viewModel.viewState {
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
    let viewModel: TransactionReceiptViewModel = .init()
    viewModel.viewState = .confirmedTransaction(txHash: "0xb13ad63a8c483265eeaef613c833def0e44a196c464c60c0c953aa83c6ab52e5")
    return TransactionReceiptView(viewModel: viewModel)
}
