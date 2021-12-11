//
//  main.swift
//  aoc-11-1
//
//  Created by Robertas on 2021-12-11.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

class Octopus {
    var energyLevel: Int
    var isHighlighted: Bool
    let row: Int
    let column: Int

    init(energyLevel level: Int, at row: Int, _ column: Int) {
        self.energyLevel = level
        self.row = row
        self.column = column
        self.isHighlighted = false
    }
}

func main() {
    print("Advent Of Code 2021: Day 11 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .components(separatedBy: "\n")
            .filter({ !$0.isEmpty })
        {
            let startTimestamp = Date().timeIntervalSince1970
            let stepAmount = 100
            print("Total of flashes after \(stepAmount) steps is: \(flashAmount(in: input, afterSteps: stepAmount))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func flashAmount(in input: [String], afterSteps stepAmount: Int) -> Int {
    let grid: [[Octopus]] = octopusGrid(from: input)
    let joinedGrid = grid.joined()
    var flashAmount = 0

    for stepNumber in 1 ... stepAmount {

        joinedGrid.forEach({ octopus in
            octopus.isHighlighted = false
            octopus.energyLevel += 1
        })
        
        while joinedGrid.contains(where: { $0.energyLevel > 9 && !$0.isHighlighted }) {
            let octopus = joinedGrid.first { $0.energyLevel > 9 && !$0.isHighlighted }!

            octopus.isHighlighted = true
            octopus.energyLevel = 0
            flashAmount += 1
            
            adjacentOctopuses(in: grid, to: octopus.row, octopus.column).forEach({ adjacentOctopus in
                if !adjacentOctopus.isHighlighted {
                    adjacentOctopus.energyLevel += 1
                }
            })
        }

        print("After step \(stepNumber):\n\(formatted(grid))\n")
    }

    return flashAmount
}

private func octopusGrid(from input: [String]) -> [[Octopus]] {
    var grid: [[Octopus]] = []

    for rowIndex in input.startIndex ..< input.endIndex {
        grid.append([])
        var columnIndex = 0

        while columnIndex < input[rowIndex].utf8.count {
            let row = input[rowIndex]
            let charIndex = row.index(row.startIndex, offsetBy: columnIndex)
            grid[rowIndex].append(Octopus(energyLevel: Int(String(row[charIndex]))!, at: rowIndex, columnIndex))
            columnIndex += 1
        }
    }
    
    return grid
}

private func adjacentOctopuses(in grid: [[Octopus]], to rowIndex: Int, _ columnIndex: Int) -> [Octopus] {
    let minRow = rowIndex - 1 < 0 ? 0 : rowIndex - 1
    let maxRow = rowIndex + 1 < grid.endIndex ? rowIndex + 1 : grid.endIndex - 1
    let minColumn = columnIndex - 1 < 0 ? 0 : columnIndex - 1
    let maxColumn = columnIndex + 1 < grid[rowIndex].endIndex ? columnIndex + 1 : grid[rowIndex].endIndex - 1
    var adjacentOctopuses: [Octopus] = []

    for row in minRow ... maxRow {
        for column in minColumn ... maxColumn {
            if row == rowIndex && column == columnIndex {
                continue
            }
            adjacentOctopuses.append(grid[row][column])
        }
    }

    return adjacentOctopuses
}

private func formatted(_ grid: [[Octopus]]) -> String {
    return grid.map({ $0.map({ "\($0.energyLevel)" }).joined() }).joined(separator: "\n")
}

main()
