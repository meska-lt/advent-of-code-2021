//
//  main.swift
//  aoc-12-1
//
//  Created by Robertas on 2021-12-11.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct PathSegment: Equatable, Hashable {
    let start: String
    let end: String

    init(start: String, end: String) {
        if start == "end" || end == "start" {
            self.start = end
            self.end = start
        } else {
            self.start = start
            self.end = end
        }
    }

}

func main() {
    print("Advent Of Code 2021: Day 12 Quest 1")
    
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
            print("Amount of paths through given cave system that visit small caves at most once is: \(distinctPathAmount(in: input))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func distinctPathAmount(in input: [String]) -> Int {
    let inputSegments = input.map({ $0.components(separatedBy: "-") }).map({ PathSegment(start: $0[0], end: $0[1] )})
    let reverseSegments = inputSegments.filter({ $0.start != "start" && $0.end != "end" }).map({ PathSegment(start: $0.end, end: $0.start) })
    let segments = inputSegments + reverseSegments
    var distinctPaths: [[String]] = endsOfPaths(in: segments, startingWith: "start").map({ ["start", $0] })

    while !distinctPaths.allSatisfy({ "end" == $0.last }) {
        distinctPaths = extend(distinctPaths, using: segments)
    }
    
    return distinctPaths.count
}

private func endsOfPaths(in segments: [PathSegment], startingWith start: String?) -> [String] {
    let startSegments = segments.filter({ $0.start == start })
        
    return startSegments.map { $0.end }
}

private func extend(_ distinctPaths: [[String]], using segments: [PathSegment]) -> [[String]] {
    var newResult: [[String]] = []

    for pathIndex in 0 ..< distinctPaths.count {
        let hasActualEnd = "end" == distinctPaths[pathIndex].last
        let newEnds = endsOfPaths(in: segments, startingWith: distinctPaths[pathIndex].last)

        if hasActualEnd {
            newResult.append(distinctPaths[pathIndex])
        } else if newEnds.count > 0 {
            for newEnd in newEnds {
                if newEnd != newEnd.lowercased() || !distinctPaths[pathIndex].contains(newEnd) {
                    newResult.append(distinctPaths[pathIndex] + [newEnd])
                }
            }
        }
    }
    
    return newResult
}

private func formatted(_ distinctPaths: [[String]]) -> [String] {
    return distinctPaths.map({ $0.joined(separator: ",") }).sorted()
}

main()
