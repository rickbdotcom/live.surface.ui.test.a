//
//  LoadingStateView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct LoadingStateView<Content: View, P: View, E: View>: View {

	@ObservedObject var loadingState: LoadingState

	var content: Content
	var progress: (Progress) -> P
	var error: (Error) -> E

    var body: some View {
		switch loadingState.state {
		case let .failure(loadingError):
			return error(loadingError).any
		case .success:
			return content.any
		default:
			return progress(loadingState.progress).any
		}
    }
}

extension View {

	func loading<P: View, E: View>(
		with loadingState: LoadingState,
		progress: @escaping (Progress) -> P,
		error: @escaping (Error) -> E
	) -> LoadingStateView<Self, P, E> {
		LoadingStateView(loadingState: loadingState, content: self, progress: progress, error: error)
	}

	func defaultLoading(with loadingState: LoadingState) -> AnyView {
		LoadingStateView(
			loadingState: loadingState,
			content: self,
			progress: { ProgressView(progress: $0) },
			error: { $0.localizedDescription.text }
		).any
	}
}
