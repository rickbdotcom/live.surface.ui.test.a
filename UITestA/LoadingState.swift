//
//  LoadingState.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

class LoadingState: ObservableObject {

	enum State {
		case idle
		case loading
		case success
		case failure(Error)
	}
	@Published var state: State = .idle

	var progress = Progress()
}
