//
//  LoadingStateView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct LoadingStateView<Content: View>: View {

	@ObservedObject var loadingState: LoadingState

	var content:  Content

    var body: some View {
        if let error = loadingState.error {
			return error.localizedDescription.text.any
		} else if loadingState.progress.isFinished {
			return content.any
		} else {
			return ProgressView(progress: loadingState.progress).any
		}
    }
}

extension View {

	func loading(with loadingState: LoadingState) -> LoadingStateView<Self> {
		LoadingStateView(loadingState: loadingState, content: self)
	}
}
