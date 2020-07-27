//
//  LoadingState.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

class LoadingState: ObservableObject {

	@Published var error: Error? = nil {
		didSet {
			isFinished = error != nil ? true : progress.isFinished
		}
	}
	@Published private(set) var isFinished: Bool = false

	var progress = Progress() {
		didSet {
			observeProgress()
		}
	}

	private var observer: NSKeyValueObservation!

	init() {
		observeProgress()
	}

	private func observeProgress() {
		observer = progress.observe(\.isFinished, options: [.initial, .old, .new]) { [weak self] progress, value in
			DispatchQueue.main.async {
				if self?.error == nil {
					self?.isFinished = value.newValue ?? false
				}
			}
		}
	}
}
