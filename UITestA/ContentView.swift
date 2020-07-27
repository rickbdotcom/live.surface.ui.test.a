//
//  ContentView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	@EnvironmentObject var imageService: ImageService

	@ObservedObject var images: ObservableArray<LiveSurfaceImage>

	@State private var cellWidth: CGFloat = 0.25
	@State private var cellHeight: CGFloat = 0.25
	@State private var editingImage: LiveSurfaceImage?

    var body: some View {
		ZStack {
			HStack {
				VStack {
					GeometryReader { g in
						GridView(numberOfColumns: self.numberOfColumns(), rowHeight: self.rowHeight(from: g.size.height), data: self.images.items) {
							self.view(for: $0)
						}
					}
					self.cellWidthSlider
				}
				self.cellHeightSlider
			}
			.defaultLoading(with: self.imageService.loadingState)

			editingView
		}
	}
}

private extension ContentView {

	var editingView: some View {
		if let editingImage = editingImage {
			return ImageEditView(image: editingImage).any
		} else {
			return EmptyView().any
		}
	}

	func view(for image: LiveSurfaceImage) -> some View {
		LiveSurfaceImageView(image: image).onTapGesture {
			self.editingImage = image
		}
	}

	func numberOfColumns() -> Int {
		Int(min(5, max(1, 1 / cellWidth)))
	}

	func rowHeight(from height: CGFloat) -> CGFloat {
		max(128, height * cellHeight)
	}

	var cellWidthSlider: some View {
		VStack {
			"Cell Width:".text
			Slider(value: self.$cellWidth).padding()
		}
	}

	var cellHeightSlider: some View {
		VStack {
			GeometryReader { geom in
				Slider(value: self.$cellHeight).padding()
					.rotationEffect(.degrees(90.0), anchor: .topLeading)
					.frame(width: geom.size.height)
					.offset(x: 80.0)
			}
			"Cell Height".text
		}
		.frame(width: 100)
		.padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
	}
}
