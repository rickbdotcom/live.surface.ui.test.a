//
//  ImageService.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Combine
import Foundation
import UIKit

class ImageService: ObservableObject {

	private(set) var loadingState = LoadingState()
	private(set) var images = ObservableArray<LiveSurfaceImage>()
	private(set) var cache = NSCache<NSString, UIImage>()

	let manifestURL: URL
	let baseImageURL: URL
	let apiKey: String
	let production: Bool
	let sessionManager = URLSession(configuration: .default)

	init(manifestURL: String, baseImageURL: String, apiKey: String, production: Bool) {
		self.manifestURL = URL(string: manifestURL)!
		self.baseImageURL = URL(string: baseImageURL)!
		self.apiKey = apiKey
		self.production = production
	}

	func initialize() {
		sessionManager.get(url: manifestURL, parameters: [
			"key": apiKey,
			"pro": production ? "1" : "0"
		], type: ImageManifest.self, loadingState: loadingState)
		.sinkOnce { images in
			self.images.items = images.images.sorted {
				$0.value.index < $1.value.index
			}.map {
				LiveSurfaceImage(id: $0.key, with: $0.value, service: self)
			}
		}
	}

// in a real app we could return image scaled to appropriate size
	func image(named name: String, for size: CGSize, loadingState: LoadingState? = nil) -> AnyPublisher<UIImage, Error> {
		if let image = cache.object(forKey: NSString(string: cacheKey(for: name, size: size))) {
			return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
		}
		return sessionManager.imageTaskPublisher(url: url(for: name, size: size), loadingState: loadingState)
	}
}


private extension ImageService {

	func url(for name: String, size: CGSize) -> URL {
		URL(string: name, relativeTo: baseImageURL)!
	}

	func localUrl(for name: String, size: CGSize) -> URL {
		URL(fileURLWithPath: "")
	}

	func cacheKey(for name: String, size: CGSize) -> String {
		name
	}
}
