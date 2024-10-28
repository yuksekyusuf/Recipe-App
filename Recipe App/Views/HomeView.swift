//
//  HomeViewModel.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(recipeService: dependencies.recipeService))
        self.dependencies = dependencies
    }
    
    private let columns: [GridItem] = [
        GridItem(.fixed(180), alignment: .top),
        GridItem(.fixed(180), alignment: .top)
    ]
    
    private var shouldShowTitle: Bool {
        !homeViewModel.isLoading && homeViewModel.errorMessage == nil && !homeViewModel.recipes.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brown.opacity(0.2).ignoresSafeArea()
                VStack {
                    if shouldShowTitle {
                        TextField("Search recipes...", text: $homeViewModel.searchText)
                            .padding(8)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .autocorrectionDisabled(true)
                    }
                    if homeViewModel.isLoading {
                        ProgressView("Loading Recipes...")
                            .foregroundColor(.indigo)
                            .bold()
                            .padding()
                    } else {
                        ScrollView {
                            if let errorMessage = homeViewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.indigo)
                                    .padding(.top, UIScreen.main.bounds.height * 0.4)
                            } else if homeViewModel.recipes.isEmpty {
                                Text(RecipeError.emptyResponse.rawValue)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.indigo)
                                    .padding(.top, UIScreen.main.bounds.height * 0.4)
                            } else {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(homeViewModel.isSearching ?
                                            homeViewModel.filteredRecipes :
                                                homeViewModel.recipes) { recipe in
                                        RecipeGridItemView(recipe: recipe,
                                                           cacheService: dependencies.cacheService)
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        .refreshable {
                            await homeViewModel.fetchRecipes()
                        }
                    }
                }
            }
            .navigationTitle(
                shouldShowTitle ?
                "Recipes: \(homeViewModel.isSearching ? homeViewModel.filteredRecipes.count : homeViewModel.recipes.count)" : "")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await homeViewModel.fetchRecipes()
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    BottomToolView(viewModel: homeViewModel)
                }
            }
        }
    }
}

#Preview {
    let dependencies = Dependencies(
        recipeService: RecipeService(),
        cacheService: CacheService())
    HomeView(dependencies: dependencies)
}
