//
//  BottomToolView.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import SwiftUI

struct BottomToolView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedButton: ButtonType? = nil
    
    enum ButtonType {
        case goodResponse, malformedResponse, emptyResponse
    }
    
    var body: some View {
        HStack {
            Button {
                selectedButton = .goodResponse
                Task {
                    await viewModel.setURL(.goodResponse)
                }
            } label: {
                VStack {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 16))
                }
                .padding(4)
                .background(
                    selectedButton == .goodResponse ?
                        .yellow.opacity(0.5) : .clear
                )
                .cornerRadius(6)
            }
            
            Button {
                selectedButton = .malformedResponse
                Task {
                    await viewModel.setURL(.malformedResponse)
                }
            } label: {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                }
                .padding(4)
                .background(
                    selectedButton == .malformedResponse ?
                        .yellow.opacity(0.5) : .clear
                )
                .cornerRadius(6)
            }
            
            Button {
                selectedButton = .emptyResponse
                Task {
                    await viewModel.setURL(.emptyResponse)
                }
            } label: {
                VStack {
                    Image(systemName: "tray.full")
                        .font(.system(size: 16))
                }
                .padding(4)
                .background(
                    selectedButton == .emptyResponse ?
                        .yellow.opacity(0.5) : .clear)
                .cornerRadius(6)
            }
            Spacer()
        }
        .cornerRadius(8)
    }
}

#Preview {
    BottomToolView(viewModel: HomeViewModel(recipeService: RecipeService()))
}
