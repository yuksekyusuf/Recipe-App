//
//  HomeViewModel.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published private(set) var errorMessage: String?
    @Published var isLoading: Bool = true
    @Published var selectedURL: String = RecipeURL.goodResponse.rawValue
    @Published private(set) var currentURL: String = RecipeURL.goodResponse.rawValue
    
    private let recipeService: RecipeServicing
    private var cancellables = Set<AnyCancellable>()
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    init(recipeService: RecipeServicing) {
        self.recipeService = recipeService
        addSearchSubscriber()
    }
    
    func fetchRecipes() async {
        errorMessage = nil
        isLoading = true
        recipes = []
        do {
            self.recipes = try await recipeService.getRecipes(from: currentURL)
        } catch let error {
            errorMessage = (error as? RecipeError)?.rawValue ?? "An unexpected error occurred."
        }
        isLoading = false
    }
    
    
    /* I initially defined the URL as a private constant inside the service class.
     However, to enable testing of error handling by the user,
     I moved the URL handling to the view model. This allows the user to switch
     between different URL options provided for the project.
     */
    func setURL(_ url: RecipeURL) async {
        guard url.rawValue != currentURL else { return }
        currentURL = url.rawValue
        selectedURL = url.rawValue
        await fetchRecipes()
    }
    
    /*
     Since this is an additional feature not required by the project description,
     I chose to use a Combine publisher for search filtering to implement debouncing
     more effectively. For the rest of the project, I handled all asynchronous tasks
     with Swift Concurrency.
     */
    private func addSearchSubscriber() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRecipes(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRecipes(searchText: String) {
        guard !searchText.isEmpty else {
            filteredRecipes = []
            return
        }
        
        return filteredRecipes = recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
}
