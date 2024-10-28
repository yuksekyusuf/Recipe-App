//
//  Dependencies.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import Foundation

class Dependencies {
    let recipeService: RecipeServicing
    let cacheService: CacheServicing
    
    init(recipeService: RecipeServicing, cacheService: CacheServicing) {
        self.recipeService = recipeService
        self.cacheService = cacheService
    }
}
