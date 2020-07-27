//
//  LiveSurfaceImage.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation
import UIKit

class LiveSurfaceImage: ObservableObject, Identifiable {
	@Published private(set) var state = LoadingState()

	let id: String

	init(id: ID, with image: ImageManifest.Images.Image) {
		self.id = id
	}

	func image() -> UIImage? {
		nil
	}
}
