//
//  CachedImageView.swift
//  Recipe App
//
//  Created by Ahmet Yusuf Yuksek on 27.10.2024.
//

import SwiftUI

struct CachedImageView: View {
    let urlString: String?
    let cacheService: CacheServicing
    @StateObject private var cachedImageViewModel: CacheImageViewModel
    
    init(urlString: String?, cacheService: CacheServicing) {
        _cachedImageViewModel = StateObject(wrappedValue: CacheImageViewModel(cacheService: cacheService))
        self.cacheService = cacheService
        self.urlString = urlString
    }
    
    var body: some View {
        ZStack {
            if let image = cachedImageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 120)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 140, height: 120)
                    .background(.secondary.opacity(0.3))
                    .cornerRadius(8)
            }
        }
        .shadow(radius: 4)
        .onAppear {
            Task(priority: .background) {
                await cachedImageViewModel.loadImage(urlString: urlString)
            }
        }
    }
}

#Preview {
    CachedImageView(urlString: Recipe.sample.photoURLLarge, cacheService: CacheService())
}
