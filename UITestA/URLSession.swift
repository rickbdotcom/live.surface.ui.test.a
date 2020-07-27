//
//  URLSession.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Combine
import Foundation
import UIKit

extension URLSession {

	func dataTaskPublisher(for url: URL, progress: ((Progress) -> Void)? = nil) -> URLSession.DataTaskPublisher {
		let publisher = dataTaskPublisher(for: url)

		if let progress = progress {
			DispatchQueue.main.async {
				self.getAllTasks { tasks in
					if let task = tasks.first(where: { $0.originalRequest?.url == url }) {
						progress(task.progress)
					}
				}
			}
		}
		return publisher
	}

	func imageTaskPublisher(url: URL, loadingState: LoadingState? = nil) -> AnyPublisher<UIImage, Error> {
		dataTaskPublisher(for: url) { loadingState?.progress = $0 }
		.receive(on: RunLoop.main)
		.compactMap { UIImage(data: $0.data) }
		.mapError { $0 as Error }
		.loadingState(loadingState)
	}

	func decodeableTaskPublisher<T: Decodable>(for url: URL, parameters: [String: String]? = nil, type: T.Type = T.self, progress: ((Progress) -> Void)? = nil) -> AnyPublisher<T, Error>  {
		var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		urlComps.queryItems = parameters?.map {
			URLQueryItem(name: $0, value: $1)
		} ?? []
		return dataTaskPublisher(for: urlComps.url!, progress: progress).map { $0.data }
			.decode(type: type, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

	func get<T: Decodable>(url: URL, parameters: [String: String]? = nil, type: T.Type = T.self, loadingState: LoadingState? = nil) -> AnyPublisher<T, Error> {
		decodeableTaskPublisher(for: url, parameters: parameters, type: type) { loadingState?.progress = $0 }
		.receive(on: RunLoop.main)
		.loadingState(loadingState)
	}
}

extension Publisher {

	func loadingState(_ loadingState: LoadingState?) -> AnyPublisher<Output, Failure> {
		handleEvents(receiveCompletion: { result in
			if case let .failure(error) = result {
				loadingState?.state = .failure(error)
			} else {
				loadingState?.state = .success
			}
		}).eraseToAnyPublisher()
	}
}
