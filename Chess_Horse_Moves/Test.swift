//
//  Test.swift
//  Chess_Horse_Moves
//
//  Created by Burak TUNA on 23.05.2020.
//  Copyright © 2020 Burak TUNA. All rights reserved.
//

import SwiftUI

struct Test: View {
    @State private var myviews = ["some text"]
    
    private func addView() {
        self.myviews.append("some new text")
    }
    
    var body: some View {
      VStack {
        ForEach(myviews, id: \.self) { myviews in
            Text(myviews)
        }
        Button(action: {self.addView()}) {
                    Text("Show details")
        }
     }
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
