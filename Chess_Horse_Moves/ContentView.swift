//
//  ContentView.swift
//  Chess_Horse_Moves
//
//  Created by Burak TUNA on 21.05.2020.
//  Copyright © 2020 Burak TUNA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    struct Chessboard: Shape {
    let rows: Int
    let columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

//      Figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

//      Loop over all rows and columns, making alternating squares colored
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
//                  This square should be colored; add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
    }
    
//  If we want to change board size we can change the two "8"
    @State private var size = 8
    @State private var stepsize: CGFloat = 360 / 8
 
    @State private var moveX: CGFloat = 0
    @State private var moveY: CGFloat = 0
    @State private var moveCount: Int = 0
    @State private var reachedBlock: [Int] = [99]
    @State private var possibbilities: String = "Empty"
    
//  Knight movement functions
    func horseMoveX(pHX: CGFloat) -> CGFloat {
        let positionHorseX = ((stepsize / 2) + 5) + (stepsize * pHX)
        return positionHorseX
    }
    func horseMoveY(pHY: CGFloat) -> CGFloat {
        let positionHorseY = (640 - (stepsize / 2)) - (stepsize * pHY)
        return positionHorseY
    }

//  Knight movement possibbilaty check functions
    func moveControl(moveV: Int) -> Int {
        var moveControlResult: Int = 0
        let controlArrayX: [CGFloat] = [(moveX + 1), (moveX + 2), (moveX + 2), (moveX + 1), (moveX - 1), (moveX - 2), (moveX - 2), (moveX - 1)]
        let controlArrayY: [CGFloat] = [(moveY + 2), (moveY + 1), (moveY - 1), (moveY - 2), (moveY - 2), (moveY - 1), (moveY + 1), (moveY + 2)]
      
        if horseMoveX(pHX: controlArrayX[moveV]) >= ((stepsize / 2) + 5) && horseMoveX(pHX: controlArrayX[moveV]) <= ((stepsize * (CGFloat(size) - 0.5)) + 5) && horseMoveY(pHY: controlArrayY[moveV]) <= (640 - (stepsize / 2)) && horseMoveY(pHY: controlArrayY[moveV]) >= (640 - (stepsize * (CGFloat(size) - 0.5))) && nil == self.reachedBlock.firstIndex(of: Int((controlArrayX[moveV] * 10) + controlArrayY[moveV])) {
        
        if controlArrayY[moveV] <= CGFloat(size - 3) && controlArrayX[moveV] <= CGFloat(size - 2) && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] + 1) * 10) + (controlArrayY[moveV] + 2)))  { moveControlResult += 1 }
        
        if controlArrayY[moveV] <= CGFloat(size - 2) && controlArrayX[moveV] <= CGFloat(size - 3) && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] + 2) * 10) + (controlArrayY[moveV] + 1))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] >= 1 && controlArrayX[moveV] <= CGFloat(size - 3) && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] + 2) * 10) + (controlArrayY[moveV] - 1))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] >= 2 && controlArrayX[moveV] <= CGFloat(size - 2) && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] + 1) * 10) + (controlArrayY[moveV] - 2))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] >= 2 && controlArrayX[moveV] >= 1 && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] - 1) * 10) + (controlArrayY[moveV] - 2))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] >= 1 && controlArrayX[moveV] >= 2 && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] - 2) * 10) + (controlArrayY[moveV] - 1))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] <= CGFloat(size - 2) && controlArrayX[moveV] >= 2 && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] - 2) * 10) + (controlArrayY[moveV] + 1))) { moveControlResult += 1 }
        
        if controlArrayY[moveV] <= CGFloat(size - 3) && controlArrayX[moveV] >= 1 && nil == self.reachedBlock.firstIndex(of: Int(((controlArrayX[moveV] - 1) * 10) + (controlArrayY[moveV] + 2))) { moveControlResult += 1 }
      }
//      Which position has not got a movement chance set it impossible
        if moveControlResult == 0 {
            moveControlResult = 9
        }
            
            return moveControlResult
        }
    
    
    var body: some View {
        
        ZStack {
           
        Chessboard(rows: size, columns: size)
            .fill(Color.black)
            .frame(width: 360, height: 360)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .position(x: 185, y:460)

        Image("Horse")
            .resizable()
            .scaleEffect(0.56 / CGFloat(self.size))
            .position(x: self.horseMoveX(pHX: self.moveX), y: self.horseMoveY(pHY: self.moveY))
            .animation(Animation.default.delay(0.3))
        
//      Start Button
        Button("Tap for the Knight's Tour") {
            
//          Start position of Knight and put into that reached blocks array
            let startPositionHorseMax = self.size - 1
            self.moveX = CGFloat(Int.random(in: 0...startPositionHorseMax))
            self.moveY = CGFloat(Int.random(in: 0...startPositionHorseMax))
            self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]

//          Set Timer for the horse movement
            var counter = 0
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ t in
            counter += 1
            
//          Control the movement possibbilaties in an array with a text
            var controlPositions = [Int]()
            for controlPosition in 0...7 {
                controlPositions += [Int(self.moveControl(moveV: controlPosition))] }
            self.possibbilities = String(controlPositions[0]) + String(controlPositions[1]) + String(controlPositions[2]) + String(controlPositions[3]) + String(controlPositions[4]) + String(controlPositions[5]) + String(controlPositions[6]) + String(controlPositions[7])
                
//          Movement Control
            if controlPositions[0] == controlPositions.min() && self.moveY <= CGFloat(self.size - 3) && self.moveX <= CGFloat(self.size - 2) && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX + 1) * 10) + (self.moveY + 2))) {
                self.moveX += 1
                self.moveY += 2
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[1] == controlPositions.min() && self.moveY <= CGFloat(self.size - 2) && self.moveX <= CGFloat(self.size - 3) && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX + 2) * 10) + (self.moveY + 1))) {
                self.moveX += 2
                self.moveY += 1
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[2] == controlPositions.min() && self.moveY >= 1 && self.moveX <= CGFloat(self.size - 3) && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX + 2) * 10) + (self.moveY - 1))) {
                self.moveX += 2
                self.moveY -= 1
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[3] == controlPositions.min() && self.moveY >= 2 && self.moveX <= CGFloat(self.size - 2) && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX + 1) * 10) + (self.moveY - 2))) {
                self.moveX += 1
                self.moveY -= 2
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[4] == controlPositions.min() && self.moveY >= 2 && self.moveX >= 1 && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX - 1) * 10) + (self.moveY - 2))) {
                self.moveX -= 1
                self.moveY -= 2
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[5] == controlPositions.min() && self.moveY >= 1 && self.moveX >= 2 && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX - 2) * 10) + (self.moveY - 1))) {
                self.moveX -= 2
                self.moveY -= 1
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[6] == controlPositions.min() && self.moveY <= CGFloat(self.size - 2) && self.moveX >= 2 && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX - 2) * 10) + (self.moveY + 1))) {
                self.moveX -= 2
                self.moveY += 1
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                
            else if controlPositions[7] == controlPositions.min() && self.moveY <= CGFloat(self.size - 3) && self.moveX >= 1 && nil == self.reachedBlock.firstIndex(of: Int(((self.moveX - 1) * 10) + (self.moveY + 2))) {
                self.moveX -= 1
                self.moveY += 2
                self.moveCount += 1
                self.reachedBlock += [Int(self.moveX * 10 + self.moveY)]
                }
                        
                if counter == (self.size * self.size) + 1 { t.invalidate() } }
                    
        } .position(x: 185, y: 50) .border(Color.red, width: 1)
            
//          Text Group for the informaton
            Text("Horse Position = " + String(Int(self.moveX)) + String(Int(self.moveY)))
            .position(x: 185, y: 125)
            
            Text("Possibbility Array = " + self.possibbilities)
            .position(x: 185, y: 175)
            
            Text("Move Count = " + String(self.moveCount))
            .position(x: 185, y: 200)
            
            Text("Last Position = " + String(self.reachedBlock[self.moveCount]))
                .position(x: 185, y: 250)
            

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
