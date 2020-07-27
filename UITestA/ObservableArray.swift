//
//  ObservableArray.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

class ObservableArray<T>: ObservableObject {
	@Published var items: [T] = []
}
