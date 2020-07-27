//
//  ImageManifest.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import Foundation

struct ImageManifest: Decodable {

	let images: Images

	struct Images: Decodable {
		let items: [String: Image]

		struct Image: Decodable {
			let index: Int
			let name: String
			let number: String
			let image: String
			let category: String
			let version: String

			let tags: [Tag]

			struct Tag: Decodable {
				let sizedescription: String
				let sizescale: String
				let sizewidth: String
				let sizewidtharc: String
				let sizeheight: String
				let sizeheightarc: String
				let sizedepth: String
				let sizedeptharc: String
				let sizeunits: String
			}
		}
	}
}
