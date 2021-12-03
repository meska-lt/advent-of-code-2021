//
//  main.swift
//  aoc-03-1
//
//  Created by Robertas on 2021-12-03.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 3 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .split(separator: "\n")
            .map(String.init)
        {
            let startTimestamp = Date().timeIntervalSince1970
            let powerConsumption = calculatePowerConsumption(using: input)
            let endTimestamp = Date().timeIntervalSince1970
            print("Power consumption of the submarine is: \(powerConsumption)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func calculatePowerConsumption(using input: [String]) -> Int {
    let positionAmount = input.first!.count
    var gammaRate = ""
    var epsilonRate = ""

    for position in 0 ..< positionAmount {
        let commonBit = mostCommonBit(in: input, position: position)

        gammaRate.append(commonBit)
        epsilonRate.append(commonBit == "1" ? "0" : "1")
    }

    return Int(gammaRate, radix: 2)! * Int(epsilonRate, radix: 2)!
}

private func mostCommonBit(in input: [String], position: Int) -> Character {
    let stuff = input.map({ row -> Character in
        return row[row.index(row.startIndex, offsetBy: position)]
    })
    let otherStuff = stuff.reduce(into: 0) { tempResult, char in
        if char == "1" {
            tempResult += 1
        }
    }
    return (otherStuff > stuff.count / 2) ? "1" : "0"
}

main()
