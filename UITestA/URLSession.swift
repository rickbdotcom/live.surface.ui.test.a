//
//  URLSession.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Combine
import Foundation

extension URLSession {

	func decodeableTaskPublisher<T: Decodable>(for url: URL, parameters: [String: String]? = nil, type: T.Type = T.self, progress: ((Progress) -> Void)? = nil) -> AnyPublisher<T, Error>  {
		var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		urlComps.queryItems = parameters?.map {
			URLQueryItem(name: $0, value: $1)
		} ?? []

		let requestURL = urlComps.url!
		let publisher = dataTaskPublisher(for: requestURL).map { $0.data }
			.decode(type: type, decoder: JSONDecoder())
			.eraseToAnyPublisher()

		DispatchQueue.main.async {
			self.getAllTasks { tasks in
				if let task = tasks.first(where: { $0.originalRequest?.url == requestURL }) {
					progress?(task.progress)
				}
			}
		}
		return publisher
	}

	func get<T: Decodable>(url: URL, parameters: [String: String]? = nil, type: T.Type = T.self, loadingState: LoadingState? = nil, completion: @escaping (T) -> Void) {
		decodeableTaskPublisher(for: url, parameters: parameters, type: type) {
			loadingState?.progress = $0
		}
		.sinkOnce(receiveCompletion: { result in
			DispatchQueue.main.async {
				if case let .failure(error) = result {
					loadingState?.error = error
				}
			}
		}, receiveValue: { value in
			DispatchQueue.main.async {
				completion(value)
			}
		})
	}
}
