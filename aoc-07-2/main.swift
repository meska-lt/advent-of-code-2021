//
//  main.swift
//  aoc-07-2
//
//  Created by Robertas on 2021-12-08.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 7 Quest 2")
    
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
            .components(separatedBy: ",")
            .compactMap({ Int($0) }) {
            let startTimestamp = Date().timeIntervalSince1970
            let fuelConsumption = minFuelConsumption(for: input)
            let endTimestamp = Date().timeIntervalSince1970
            print("Least fuel consumption to align positions: \(fuelConsumption)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func minFuelConsumption(for positions: [Int]) -> Int {
    var optimalConsumption = Int.max

    for targetPosition in positions.min()! ... positions.max()! {
        let consumption = positions.reduce(into: 0) { result, initialPosition in
            let distance = abs(initialPosition.distance(to: targetPosition))
            result += (0 ... distance).reduce(into: 0, { subResult, subConsumption in subResult += subConsumption })
//            for intermediateDistance in 0 ... distance {
//                result += intermediateDistance
//            }
        }

        optimalConsumption = min(optimalConsumption, consumption)
    }

    return optimalConsumption
}

main()
