//
//  main.swift
//  aoc-02-2
//
//  Created by Robertas on 2021-12-02.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 2 Quest 2")
    
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
            .map({ $0.split(separator: " ") })
        {
            let startTimestamp = Date().timeIntervalSince1970
            var horizontalPosition = 0
            var depth = 0
            var aim = 0

            for command in input {
                let direction = command[0]
                let shift = Int(command[1])!

                switch direction {
                case "forward":
                    horizontalPosition += shift
                    depth += aim * shift
                case "up": aim -= shift
                case "down": aim += shift
                default: break
                }
            }
            let result = depth * horizontalPosition
            let endTimestamp = Date().timeIntervalSince1970
            print("Horizontal position multiplied by final depth: \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

main()
