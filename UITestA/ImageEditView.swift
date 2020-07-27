//
//  ImageEditView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct ImageEditView: View {

	@ObservedObject var image: LiveSurfaceImage
	@State private var uiImage: UIImage?

	var body: some View {
		editingView
			.onReceive(image.image(for: .zero).replaceError(with: UIImage())) { image in
				if self.uiImage == nil {
					self.uiImage = image
				}
			}
	}
}

private extension ImageEditView {

	var editingView: some View {
		guard let uiImage = uiImage else {
			return EmptyView().any
		}
		return ZStack {
			uiImage.image.resizable().blur(radius: 20)
			uiImage.image.resizable().aspectRatio(contentMode: .fit)
		}.any
	}
}
