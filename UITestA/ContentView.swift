//
//  ContentView.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	struct TestData: Identifiable {
		let id: String
	}
    var body: some View {
		GridView(numberOfColumns: 2, data: [
			TestData(id: "1"),
			TestData(id: "2"),
			TestData(id: "3")

		] ) {
			Text($0.id)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
