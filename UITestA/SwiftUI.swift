//
//  SwiftUI.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension View {

	var any: AnyView {
		AnyView(self)
	}
}

extension String {

	var text: Text {
		Text(self)
	}
}

extension UIImage {

	 var image: Image {
		Image(uiImage: self)
	}
}
