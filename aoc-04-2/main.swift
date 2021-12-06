//
//  main.swift
//  aoc-04-2
//
//  Created by Robertas on 2021-12-06.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

class Slot: Equatable {
    static func == (lhs: Slot, rhs: Slot) -> Bool {
        return lhs.value == rhs.value
    }
    
    let value: Int
    var isMarked = false

    init(_ number: Int) {
        value = number
    }
}

class Board: Equatable {
    static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.rows == rhs.rows
    }
    
    var rows: [[Slot]] = []

    init(with slotRows: [[Slot]]) {
        rows.append(contentsOf: slotRows)
    }
}

func main() {
    print("Advent Of Code 2021: Day 4 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .components(separatedBy: "\n\n")
        {
            let startTimestamp = Date().timeIntervalSince1970
            playBingo(using: input)
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func playBingo(using input: [String]) {
    let order = input.first!.split(separator: ",").map({ Int($0)! })
    var boards = parseBoards(Array(input.dropFirst()))

    for number in order {
        mark(number, in: &boards)
        
        if let board = winningBoard(in: boards) {
            if boards.count > 1 {
                boards.removeAll(where: { $0 == board })
            }

            print("Score of the winning board is: \(unmarkedSum(of: board) * number)")
        }
    }
}

private func parseBoards(_ input: [String]) -> [Board] {
    return input.map({ board in
        let slotRows = board.split(separator: "\n")
            .map(String.init)
            .map({ slots(in: $0) })
        
        return Board(with: slotRows)
    })
}

private func mark(_ number: Int, in boards: inout [Board]) {
    boards.forEach { board in
        for row in board.rows {
            for slot in row {
                if !slot.isMarked {
                    slot.isMarked = slot.value == number
                }
            }
        }
    }
}

private func winningBoard(in boards: [Board]) -> Board? {
    return boards.first { board -> Bool in
        if let winningRow = board.rows.first(where: { row -> Bool in
            row.allSatisfy { $0.isMarked }
        }) {
//            print("Winning row: \(winningRow.map { $0.value } )")
            return true
        } else if let winningColumn = (board.rows.startIndex ..< board.rows.endIndex).firstIndex(where: { columnIndex -> Bool in
            board.rows.map({ $0[columnIndex] }).allSatisfy { $0.isMarked }
        }) {
//            print("Winning column: \(board.rows.map { $0[winningColumn].value } )")
            return true
        }

        return false
    }
}

private func slots(in row: String) -> [Slot] {
    var rowSlots: [Slot] = []
    var currentIndex = row.startIndex

    while currentIndex < row.endIndex {
        let numberString = "\(row[currentIndex])\(row[row.index(after: currentIndex)])".trimmingCharacters(in: .whitespaces)
        rowSlots.append(Slot(Int(numberString)!))
        
        currentIndex = row.index(currentIndex, offsetBy: 3, limitedBy: row.endIndex) ?? row.endIndex
    }
    
    
    return rowSlots
}

private func unmarkedSum(of board: Board) -> Int {
   return board.rows.reduce(into: 0) { boardResult, row in
       boardResult += row.reduce(into: 0, { rowResult, slot in
           rowResult += slot.isMarked ? 0 : slot.value
       })
   }
}

main()
