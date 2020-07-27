//
//  LiveSurfaceImage.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Combine
import Foundation
import UIKit

class LiveSurfaceImage: ObservableObject, Identifiable {
	@Published private(set) var loadingState = LoadingState()
	@Published private(set) var operations = [ImageOperation]()

	let id: String
	let manifestImage: ImageManifest.Image

	private weak var imageService: ImageService!
	private var image: UIImage?

	init(id: ID, with image: ImageManifest.Image, service: ImageService) {
		self.id = id
		self.imageService = service
		self.manifestImage = image
		self.operations = service.operations(for: image.image)
	}

	func image(for size: CGSize) -> AnyPublisher<UIImage, Error> {
		imageService.image(named: manifestImage.image, for: size, loadingState: loadingState)
	}

	func apply(operation: ImageOperation) {
		operations.append(operation)
		imageService.save(operations: operations, for: manifestImage.image)
	}

	func undoOperation() {
		if operations.isEmpty == false {
			operations.removeLast()
			imageService.save(operations: operations, for: manifestImage.image)
		}
	}
}
