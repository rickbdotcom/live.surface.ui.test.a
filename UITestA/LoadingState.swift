//
//  LoadingState.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

class LoadingState: ObservableObject {
	@Published var progress: Progress
	@Published var error: Error?

	init() {
		progress = Progress()
		error = nil
	}
}
