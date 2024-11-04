//
//  RecipeURL.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import Foundation


enum RecipeURL {
    case goodResponse
    case malformedResponse
    case emptyResponse
    case custom(String) // For testing
    
    var rawValue: String {
        switch self {
        case .goodResponse:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case .malformedResponse:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case .emptyResponse:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        case .custom(let urlString):
            return urlString
        }
    }
}
