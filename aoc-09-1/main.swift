//
//  main.swift
//  aoc-09-1
//
//  Created by Robertas on 2021-12-09.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 9 Quest 1")
    
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
            .map({ $0.map({ Int(String($0))! }) })
        {
            let startTimestamp = Date().timeIntervalSince1970
            print("The sum of the risk levels of all low points on heightmap: \(riskLevelSum(of: input))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func riskLevelSum(of input: [[Int]]) -> Int {
    var lowPoints: [Int] = []

    for row in input.startIndex ..< input.endIndex {
        for column in input[row].startIndex ..< input[row].endIndex {
            if isLowPoint(in: input, at: row, column) {
                lowPoints.append(input[row][column])
            }
        }
    }

    return lowPoints.reduce(into: 0) { result, lowPoint in
        result += lowPoint + 1
    }
}

private func isLowPoint(in input: [[Int]], at rowIndex: Int, _ column: Int) -> Bool {
    let height = input[rowIndex][column]
    
    return height < adjacentHeights(in: input, to: rowIndex, column).min()!
}

private func adjacentHeights(in input: [[Int]], to rowIndex: Int, _ column: Int) -> [Int] {
    var adjacentHeights: [Int] = []

    if column > input[rowIndex].startIndex {
        adjacentHeights.append(input[rowIndex][column - 1])
    }

    if column < input[rowIndex].index(before: input[rowIndex].endIndex) {
        adjacentHeights.append(input[rowIndex][column + 1])
    }

    if rowIndex > input.startIndex {
        adjacentHeights.append(input[rowIndex - 1][column])
    }

    if rowIndex < input.index(before: input.endIndex) {
        adjacentHeights.append(input[rowIndex + 1][column])
    }

    return adjacentHeights
}

main()
