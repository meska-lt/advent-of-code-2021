//
//  main.swift
//  aoc-08-1
//
//  Created by Robertas on 2021-12-08.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 8 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
            .filter({ !$0.isEmpty })
        {
            let startTimestamp = Date().timeIntervalSince1970
            print("Times digits 1, 4, 7, or 8 did appear: \(easyDigitAppearances(in: input))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func easyDigitAppearances(in input: [String]) -> Int {
    return input.reduce(into: 0, { result, entry in
        let fourDigitOutput = entry.components(separatedBy: " | ").last!.components(separatedBy: " ")

        fourDigitOutput.forEach { digit in
            switch digit.utf8.count {
            case 2, 3, 4, 7: result += 1
            default: break
            }
        }
    })
}

main()
