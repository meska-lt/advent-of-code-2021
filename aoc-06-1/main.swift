//
//  main.swift
//  aoc-06-1
//
//  Created by Robertas on 2021-12-07.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

class Fish {

    private static let bornDelay = 2
    private static let spawnInterval = 7

    var internalTimer: Int
    
    init() {
        internalTimer = Fish.bornDelay + Fish.spawnInterval
    }

    init(with timerValue: Int) {
        internalTimer = timerValue
    }

    func resetTimer() {
        internalTimer += Fish.spawnInterval
    }
}

func main() {
    print("Advent Of Code 2021: Day 6 Quest 1")
    
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
            let dayLimit = 80
            let swarmSize = calculateSize(swarm: input, after: dayLimit)
            let endTimestamp = Date().timeIntervalSince1970
            print("After \(dayLimit) day(s) swarm size would be: \(swarmSize)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func calculateSize(swarm input: [Int], after dayLimit: Int) -> Int {
    var fishSwarm = input.map({ Fish(with: $0) })

    for _ in 1 ... dayLimit {
        fishSwarm.filter({ $0.internalTimer == 0 }).forEach({ _ in fishSwarm.append(Fish()) })
        fishSwarm.forEach({ $0.internalTimer -= 1 })
        fishSwarm.filter({ $0.internalTimer == -1 }).forEach({ $0.resetTimer() })
    }

    return fishSwarm.count
}

main()
