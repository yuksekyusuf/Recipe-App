//
//  CacheImageViewModel_Tests.swift
//  Recipe AppTests
//
//  Created by Ahmet Yusuf Yuksek on 28.10.2024.
//

import XCTest
import UIKit
@testable import Recipe_App

class MockCacheService: CacheServicing {
    var images: [String: UIImage] = [:]
    var fetchImageCalled = false
    var saveImageCalled = false
    
    func fetchImage(key: String) async -> UIImage? {
        fetchImageCalled = true
        return images[key]
    }
    
    func saveImage(key: String, image: UIImage) async {
        saveImageCalled = true
        images[key] = image
    }
}

@MainActor
final class CacheImageViewModel_Tests: XCTestCase {
    
    var viewModel: CacheImageViewModel!
    var mockCacheService: MockCacheService!
    
    override func setUp() {
        super.setUp()
        mockCacheService = MockCacheService()
        viewModel = CacheImageViewModel(cacheService: mockCacheService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCacheService = nil
        super.tearDown()
    }
    
    func test_CacheImageViewModel_loadImage_shouldReturnSameImageWithCachedImage() async {
        //Given
        let urlString = "testImageKey"
        let cachedImage = UIImage(systemName: "star")!
        mockCacheService.images[urlString] = cachedImage
        
        //When
        await viewModel.loadImage(urlString: urlString)
        
        //Then
        XCTAssertEqual(viewModel.image?.pngData(), cachedImage.pngData())
        XCTAssertTrue(mockCacheService.fetchImageCalled)
        XCTAssertFalse(mockCacheService.saveImageCalled)
    }
}
