//
//  LiveSurfaceImageView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct LiveSurfaceImageView: View {

	@ObservedObject var image: LiveSurfaceImage
	@State private var uiImage: UIImage?

	var body: some View {
		self.imageView
			.defaultLoading(with: self.image.loadingState)
			.onAppear {
				self.image.image(for: .zero).sinkOnce {
					self.uiImage = $0
				}
			}
	}
}

private extension LiveSurfaceImageView {

	var imageView: some View {
		if let uiImage = uiImage {
			return ZStack {
				uiImage.image.resizable().blur(radius: 20)
				uiImage.image.resizable().aspectRatio(contentMode: .fit)
			}.any
		} else {
			return EmptyView().any
		}
	}
}
