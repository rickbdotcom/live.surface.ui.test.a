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
			loadingState?.state = .success
			return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
		}

		let localUrl = self.localUrl(for: name, size: size)
		if FileManager.default.fileExists(atPath: localUrl.path) {
			loadingState?.state = .success
			return Just(UIImage(contentsOfFile: localUrl.path) ?? UIImage()).setFailureType(to: Error.self).eraseToAnyPublisher()
		}

		return sessionManager.dataTaskPublisher(for: url(for: name, size: size)) {
			loadingState?.progress = $0
		}.compactMap {
			if let image = UIImage(data: $0.data) {
				self.cache(data: $0.data, name: name, size: size)
				return image
			} else {
				return nil
			}
		}
		.mapError { $0 as Error }
		.receive(on: RunLoop.main)
		.loadingState(loadingState)
	}

	func operations(for name: String) -> [ImageOperation] {
		do {
			let data = try Data(contentsOf: operationUrl(for: name))
			return try JSONDecoder().decode([ImageOperation].self, from: data)
		} catch {
			return []
		}
	}

	func save(operations: [ImageOperation], for name: String) {
		do {
			try JSONEncoder().encode(operations).write(to: operationUrl(for: name))
		} catch {
		}
	}
}


private extension ImageService {

	func operationUrl(for name: String) -> URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name).appendingPathExtension("json")
	}

	func cache(data: Data, name: String, size: CGSize) {
		let localUrl = self.localUrl(for: name, size: size)
		try? data.write(to: localUrl)
	}

	func url(for name: String, size: CGSize) -> URL {
		URL(string: name, relativeTo: baseImageURL)!
	}

	func localUrl(for name: String, size: CGSize) -> URL {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(cacheKey(for: name, size: size))
	}

	func cacheKey(for name: String, size: CGSize) -> String {
		name
	}
}
