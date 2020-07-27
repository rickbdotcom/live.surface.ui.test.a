//
//  ImageOperation.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

enum ImageOperation: String, Codable {

	case flipHorizontal
	case flipVertical
	case rotateClockwise
	case rotateCounterClockwise

	func modify<T: View>(_ view: T) -> AnyView {
		switch self {
		case .flipHorizontal:
			return view.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)).any
		case .flipVertical:
			return view.rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0)).any
		case .rotateClockwise:
			return view.rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1)).any
		case .rotateCounterClockwise:
			return view.rotation3DEffect(.degrees(-90), axis: (x: 0, y: 0, z: 1)).any
		}
	}
}


extension View {

	func modify(with op: ImageOperation) -> some View {
		op.modify(self)
	}

	func modify(with ops: [ImageOperation]) -> some View {
		var view: AnyView = self.any
		ops.forEach {
			view = view.modify(with: $0).any
		}
		return view
	}
}
