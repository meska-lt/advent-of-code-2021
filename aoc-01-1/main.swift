//
//  main.swift
//  aoc-01-1
//
//  Created by Robertas on 2021-12-01.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 1 Quest 1")
    
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
            var result = 0
            for iterator in 1 ..< input.count {
                if input[iterator-1] < input[iterator] {
                    result += 1
                }
            }
            let endTimestamp = Date().timeIntervalSince1970
            print("The number of times a depth measurement increases: \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

main()
