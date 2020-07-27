//
//  ContentView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var images: ObservableArray<LiveSurfaceImage>

    var body: some View {
		GridView(numberOfColumns: 2, data:
			images.items
		) {
			Text($0.id)
		}
	}
}
