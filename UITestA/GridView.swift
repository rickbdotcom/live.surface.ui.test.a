//
//  GridView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

// in iOS 14 we'd just use the new lazy grid view
struct GridView<Cell: View, Data: Identifiable>: View {

	let numberOfColumns: Int
	let data: [Data]
	let cell: (Data) -> Cell

	private var rows: [DataRow] {
		data.chunked(into: numberOfColumns).map {
			DataRow(columns: $0)
		}
	}

	var body: some View {
		GeometryReader { geom in
			List() {
				ForEach(self.rows, id: \.id) { row in
					HStack(spacing: 0) {
						ForEach(row.columns) {
							self.cell($0)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.frame(width: geom.size.width / 2.0)
								.background(Color.red)
						}
					}.listRowInsets(EdgeInsets())
				}
			}
		}
	}

	struct DataRow: Identifiable {
		let id: Hash
		let columns: [Data]

		init(columns: [Data]) {
			self.columns = columns
			id = Hash(ids: columns.map { $0.id} )
		}
		struct Hash: Hashable {
			let ids: [Data.ID]

			var hash: Int {
				var hasher = Hasher()
				ids.forEach {
					hasher.combine($0)
				}
				return hasher.finalize()
			}
		}
	}
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
