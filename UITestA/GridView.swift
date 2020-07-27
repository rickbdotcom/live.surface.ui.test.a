//
//  GridView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct GridView<Cell: View, Data: Identifiable>: View {

	let numberOfColumns: Int
	let rowHeight: CGFloat

	let data: [Data]
	let cell: (Data) -> Cell

	private var rows: [DataRow] {
		data.chunked(into: numberOfColumns).enumerated().map { i, columns in
			DataRow(columns: columns, id: i)
		}
	}

	var body: some View {
		GeometryReader { g in
			List() {
				ForEach(self.rows, id: \.id) { row in
					HStack(spacing: 0) {
						ForEach(row.columns) {
							self.cell($0)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.frame(width: g.size.width / CGFloat(self.numberOfColumns), height: self.rowHeight)
						}
					}.listRowInsets(EdgeInsets())
				}
			}
		}
	}

	struct DataRow: Identifiable {
		let id: Int
		let columns: [Data]

		init(columns: [Data], id: Int) {
			self.columns = columns
			self.id = id
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
