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
	@Binding var isPresented: Bool

	var body: some View {
		ZStack {
			LiveSurfaceImageView(image: image)
		}
		.overlay(editControls)
	}
}


private extension ImageEditView {

	var editControls: some View {
		GeometryReader { g in
			VStack(spacing: 30) {
				"Flip Horizontal".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.image.apply(operation: .flipHorizontal)
				}
				"Flip Vertical".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.image.apply(operation: .flipVertical)
				}
				"Rotate Right".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.image.apply(operation: .rotateClockwise)
				}
				"Rotate Left".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.image.apply(operation: .rotateCounterClockwise)
				}
				"Undo".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.image.undoOperation()
				}
				"Done".text.font(.system(size: 48)).contentShape(Rectangle()).onTapGesture {
					self.isPresented = false
				}
			}
			.frame(maxHeight: .infinity, alignment: .trailing)
			.padding()
			.background(Color.white)
			.opacity(0.5)
			.frame(width: g.size.width, alignment: .trailing)
		}.zIndex(1)
	}
}
