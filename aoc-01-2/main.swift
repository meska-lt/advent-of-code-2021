//
//  main.swift
//  aoc-01-2
//
//  Created by Robertas on 2021-12-01.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 1 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.split(separator: "\n").map(String.init).compactMap(Int.init) {
            let startTimestamp = Date().timeIntervalSince1970

            let windowSize = 3
            let endIndex = input.count - windowSize
            var result = 0

            for iterator in 1 ... endIndex {
                if sumOfThree(input[(iterator - 1)...(iterator+1)]) < sumOfThree(input[iterator...(iterator+2)]) {
                    result += 1
                }
            }
            let endTimestamp = Date().timeIntervalSince1970
            print("The number of times a depth measurement in sliding window increases: \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func sumOfThree(_ three: ArraySlice<Int>) -> Int {
    return three.reduce(into: 0) { tempResult, inputPart in
        tempResult += inputPart
    }
}

main()
