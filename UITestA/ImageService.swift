//
//  ImageService.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

class ImageService: ObservableObject {

	private(set) var state = LoadingState()
	private(set) var images = ObservableArray<LiveSurfaceImage>()

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
		], type: ImageManifest.self, loadingState: state) { images in
			self.images.items = images.images.sorted {
				$0.value.index < $1.value.index
			}.map {
				LiveSurfaceImage(id: $0.key, with: $0.value)
			}
		}
	}
}
