//
//  RecipeService.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import Foundation

protocol RecipeServicing {
    func getRecipes(from url: String) async throws -> [Recipe]
}

class RecipeService: RecipeServicing {
    func getRecipes(from url: String) async throws -> [Recipe] {
        guard let requestUrl = URL(string: url) else {
            throw RecipeError.unableToComplete
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: requestUrl)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RecipeError.invalidResponse
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                return result.recipes
            } catch {
                throw RecipeError.invalidData
            }
        } catch let error as RecipeError {
            throw error
        } catch {
            throw RecipeError.unableToComplete
        }
    }
}
