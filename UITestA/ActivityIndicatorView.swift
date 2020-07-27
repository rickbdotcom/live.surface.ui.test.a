//
//  ActivityIndicatorView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {

	func makeUIView(context: Context) -> UIActivityIndicatorView {
		let view = UIActivityIndicatorView()
		view.startAnimating()
		return view
	}

	func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
	}
}
