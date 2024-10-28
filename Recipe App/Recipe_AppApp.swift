//
//  Recipe_AppApp.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import SwiftUI

@main
struct Recipe_AppApp: App {
    let dependencies = Dependencies(
        recipeService: RecipeService(),
        cacheService: CacheService())
    
    var body: some Scene {
        WindowGroup {
            HomeView(dependencies: dependencies)
        }
    }
}
