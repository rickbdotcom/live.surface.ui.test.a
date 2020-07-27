//
//  ProgressView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI
import UIKit

struct ProgressView: UIViewRepresentable {

	let progress: Progress

	func makeUIView(context: Context) -> UIProgressView {
		let progressView = UIProgressView()
		progressView.observedProgress = progress
		return progressView
	}

	func updateUIView(_ uiView: UIProgressView, context: Context) {
	}
}
