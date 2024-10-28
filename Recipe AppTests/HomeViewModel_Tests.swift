//
//  HomeViewModel_Tests.swift
//  Recipe AppTests
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import XCTest
import Combine
@testable import Recipe_App

class MockRecipeService: RecipeServicing {
    var shouldThrowError = false
    var mockRecipes: [Recipe] = []
    
    func getRecipes(from url: String) async throws -> [Recipe] {
        if shouldThrowError {
            throw RecipeError.invalidResponse
        }
        return mockRecipes
    }
}

@MainActor
final class HomeViewModel_Tests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockService: MockRecipeService!
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        viewModel = HomeViewModel(recipeService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_HomeViewModel_initialization() {
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.filteredRecipes.count, 0)
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.selectedURL, RecipeURL.goodResponse.rawValue)
        XCTAssertEqual(viewModel.currentURL, RecipeURL.goodResponse.rawValue)
    }
    
    func test_HomeViewModel_fetchRecipes_shouldSuccess() async {
        //Given
        mockService.mockRecipes = [
            Recipe(
                id: "1",
                cuisine: "Italian", name: "Pasta",
                photoURLLarge: "https://example.com/pasta_large.jpg",
                photoURLSmall: "https://example.com/pasta_small.jpg",
                sourceURL: "https://example.com/pasta_recipe",
                youtubeURL: "https://youtube.com/pasta_recipe"
            )
        ]
        
        //When
        await viewModel.fetchRecipes()
        
        //
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Pasta")
    }
    
    func test_HomeViewModel_fetchRecipes_shouldFail() async {
        //Given
        mockService.shouldThrowError = true
        
        //When
        await viewModel.fetchRecipes()
        
        //Then
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_HomeViewModel_setUrl_shouldUpdateRecipesAndCurrentURL() async {
        //Given
        let newURL = RecipeURL.custom("https://newurl.com")
        mockService.mockRecipes = [
            Recipe(
                id: "2",
                cuisine: "Japanese", name: "Sushi",
                photoURLLarge: "https://example.com/sushi_large.jpg",
                photoURLSmall: "https://example.com/sushi_small.jpg",
                sourceURL: "https://example.com/sushi_recipe",
                youtubeURL: "https://youtube.com/sushi_recipe"
            )
        ]
        
        //When
        await viewModel.setURL(newURL)
        
        //Then
        XCTAssertEqual(viewModel.currentURL, newURL.rawValue)
        XCTAssertEqual(viewModel.selectedURL, newURL.rawValue)
        XCTAssertEqual(viewModel.recipes.first?.name, "Sushi")
    }
    
    func test_HomeViewModel_isSeaching_shouldBeTrue() {
        //When
        viewModel.searchText = "Pizza"
        
        //Then
        XCTAssertTrue(viewModel.isSearching)
        
    }
    
    func test_HomeViewModel_filteredRecipes_shouldSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Search debounce")
        mockService.mockRecipes = [
            Recipe(
                id: "1",
                cuisine: "Italian", name: "Pasta",
                photoURLLarge: "https://example.com/pasta_large.jpg",
                photoURLSmall: "https://example.com/pasta_small.jpg",
                sourceURL: "https://example.com/pasta_recipe",
                youtubeURL: "https://youtube.com/pasta_recipe"
            ),
            Recipe(
                id: "2",
                cuisine: "Japanese", name: "Sushi",
                photoURLLarge: "https://example.com/sushi_large.jpg",
                photoURLSmall: "https://example.com/sushi_small.jpg",
                sourceURL: "https://example.com/sushi_recipe",
                youtubeURL: "https://youtube.com/sushi_recipe"
            )
        ]
        viewModel.recipes = mockService.mockRecipes
        
        // When
        viewModel.searchText = "Sushi"
        
        // Wait for debounce
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Then
            XCTAssertEqual(self.viewModel.filteredRecipes.count, 1)
            XCTAssertEqual(self.viewModel.filteredRecipes.first?.name, "Sushi")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_HomeViewModel_filteredRecipes_shouldEmptySearchSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Search debounce")
        viewModel.filteredRecipes = [
            Recipe(
                id: "2",
                cuisine: "Japanese", name: "Sushi",
                photoURLLarge: "https://example.com/sushi_large.jpg",
                photoURLSmall: "https://example.com/sushi_small.jpg",
                sourceURL: "https://example.com/sushi_recipe",
                youtubeURL: "https://youtube.com/sushi_recipe"
            )
        ]
        
        // When
        viewModel.searchText = ""
        
        // Wait for debounce
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Then
            XCTAssertEqual(self.viewModel.filteredRecipes.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
