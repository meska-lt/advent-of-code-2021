//
//  main.swift
//  aoc-12-2
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

class Path {
    var isSmallCaveAddedTwice = false
    var segments: [String] = []

    func extended(with segment: String) -> Path {
        let newPath = Path()
        newPath.isSmallCaveAddedTwice = isSmallCaveAddedTwice || segment == segment.lowercased() && segments.contains(segment)
        newPath.segments = segments + [segment]
        return newPath
    }

    func canExtend(with segment: String) -> Bool {
        if segment == segment.uppercased() || !isSmallCaveAddedTwice {
            return true
        } else {
            return !segments.contains(segment)
        }
    }
}

func main() {
    print("Advent Of Code 2021: Day 12 Quest 2")
    
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
    var distinctPaths: [Path] = endsOfPaths(in: segments, startingWith: "start")
        .map({ end in
            let path = Path()
            path.segments = ["start", end]
            return path
        })

    while !distinctPaths.allSatisfy({ "end" == $0.segments.last }) {
        distinctPaths = extend(distinctPaths, using: segments)
    }
    
    return distinctPaths.count
}

private func endsOfPaths(in segments: [PathSegment], startingWith start: String?) -> [String] {
    let startSegments = segments.filter({ $0.start == start })
        
    return startSegments.map { $0.end }
}

private func extend(_ distinctPaths: [Path], using segments: [PathSegment]) -> [Path] {
    var newResult: [Path] = []

    for pathIndex in 0 ..< distinctPaths.count {
        let hasActualEnd = "end" == distinctPaths[pathIndex].segments.last
        let newEnds = endsOfPaths(in: segments, startingWith: distinctPaths[pathIndex].segments.last)

        if hasActualEnd {
            newResult.append(distinctPaths[pathIndex])
        } else if newEnds.count > 0 {
            for newEnd in newEnds {
                if distinctPaths[pathIndex].canExtend(with: newEnd) {
                    newResult.append(distinctPaths[pathIndex].extended(with: newEnd))
                }
            }
        }
    }

    return newResult
}

private func formatted(_ distinctPaths: [Path]) -> String {
    return distinctPaths.map({ $0.segments }).map({ $0.joined(separator: ",") }).sorted().joined(separator: "\n")
}

main()
