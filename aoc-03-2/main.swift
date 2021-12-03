//
//  main.swift
//  aoc-03-2
//
//  Created by Robertas on 2021-12-03.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 3 Quest 2")
    
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
            let oxygenGeneratorRating = findOxygenGeneratorRating(using: input)
            let co2ScrubberRating = findCO2ScrubberRating(using: input)
            let lifeSupportRating = oxygenGeneratorRating * co2ScrubberRating
            let endTimestamp = Date().timeIntervalSince1970
            print("Life support rating of the submarine is: \(lifeSupportRating)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func findOxygenGeneratorRating(using input: [String], position: Int = 0) -> Int {
    let commonBit = mostCommonBit(in: input, position: position)
    let matchingNumbers = input.filter({ $0[$0.index($0.startIndex, offsetBy: position)] == commonBit })
    
    if (matchingNumbers.count == 1) {
        return Int(matchingNumbers.first!, radix: 2)!
    } else {
        return findOxygenGeneratorRating(using: matchingNumbers, position: (position + 1))
    }
}

private func findCO2ScrubberRating(using input: [String], position: Int = 0) -> Int {
    let commonBit = leastCommonBit(in: input, position: position)
    let matchingNumbers = input.filter({ $0[$0.index($0.startIndex, offsetBy: position)] == commonBit })
    
    if (matchingNumbers.count == 1) {
        return Int(matchingNumbers.first!, radix: 2)!
    } else {
        return findCO2ScrubberRating(using: matchingNumbers, position: (position + 1))
    }
}

private func mostCommonBit(in input: [String], position: Int) -> Character {
    let positionCharacters = input.map({ $0[$0.index($0.startIndex, offsetBy: position)]})
    let zeroOccurences = positionCharacters.reduce(into: 0) { tempResult, char in
        if char == "0" {
            tempResult += 1
        }
    }

    let isEqualOccurenceAmount = zeroOccurences == (positionCharacters.count / 2)

    if isEqualOccurenceAmount {
        return "1"
    }

    return (zeroOccurences > positionCharacters.count / 2) ? "0" : "1"
}

private func leastCommonBit(in input: [String], position: Int) -> Character {
    let positionCharacters = input.map({ $0[$0.index($0.startIndex, offsetBy: position)]})
    let zeroOccurences = positionCharacters.reduce(into: 0) { tempResult, char in
        if char == "0" {
            tempResult += 1
        }
    }

    let isEqualOccurenceAmount = zeroOccurences == (positionCharacters.count / 2)

    if isEqualOccurenceAmount {
        return "0"
    }

    return (zeroOccurences > positionCharacters.count / 2) ? "1" : "0"
}

main()
