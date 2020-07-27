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
		imageView
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
			return GeometryReader { g in
				ZStack {
					uiImage.image.resizable().blur(radius: 20)
					uiImage.image.resizable().aspectRatio(contentMode: .fit)
					VStack(alignment: .leading) {
						self.image.manifestImage.number.text.font(.system(size: 32))
						self.image.manifestImage.name.text.font(.system(size: 20))
					}
					.opacity(0.5).padding()
					.frame(width: g.size.width, height: g.size.height, alignment: .topLeading)
				}
			}.any
		} else {
			return Color.white.any
		}
	}
}
