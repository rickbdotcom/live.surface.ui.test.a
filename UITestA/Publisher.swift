//
//  Publisher.swift
//  Logistics
//
//  Created by rickb on 1/28/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Combine
import Foundation

extension Publisher {

	@discardableResult
	func sinkOnce(receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)? = nil, receiveValue: ((Output) -> Void)? = nil) -> Cancellable {
		subscribeUntilCompletion { done in
			self.sink(receiveCompletion: { result in
				receiveCompletion?(result)
				done()
			}, receiveValue: { value in
				receiveValue?(value)
				DispatchQueue.main.async {
					done()
				}
			})
		}
	}
}

@discardableResult
func subscribeUntilCompletion(_ block: @escaping (@escaping () -> Void) -> Cancellable) -> Cancellable {
	var subscription: Cancellable?
	subscription = block {
		if subscription != nil {
			subscription = nil
		}
	}
	return ExplicitCancellable {
		subscription?.cancel()
		subscription = nil
	}
}

private struct ExplicitCancellable: Cancellable {
	let cancelBlock: () -> Void

	func cancel() {
		cancelBlock()
	}
}
