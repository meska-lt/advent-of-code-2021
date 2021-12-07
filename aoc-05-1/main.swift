//
//  main.swift
//  aoc-05-1
//
//  Created by Robertas on 2021-12-07.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Segment {
    let x, y: Int

    init(_ segmentDescription: String) {
        let descriptionParts = segmentDescription.split(separator: ",").map(String.init)
        x = Int(descriptionParts.first!)!
        y = Int(descriptionParts.last!)!
    }
}

struct Line {
    let start, end: Segment

    init(_ lineDescription: String) {
        let segmentStrings = lineDescription.components(separatedBy: " -> ")

        start = Segment(segmentStrings.first!)
        end = Segment(segmentStrings.last!)
    }
}

func main() {
    print("Advent Of Code 2021: Day 5 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .components(separatedBy: "\n").filter({ !$0.isEmpty })
        {
            let startTimestamp = Date().timeIntervalSince1970
            let overlapMinimum = 2
            let result = amountOfOverlappingPoints(in: input, minOverlaps: overlapMinimum)
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
            print("Amount of points at which at least \(overlapMinimum) lines overlap: \(result)")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func amountOfOverlappingPoints(in input: [String], minOverlaps: Int) -> Int {
    let lines = input.map(Line.init)
    var diagram: [[Int]] = createDiagram(using: lines)

    for line in lines {
        update(&diagram, using: line)
    }

    return diagram.flatMap({ $0 }).filter({ $0 >= minOverlaps}).count
}

private func createDiagram(using lines: [Line]) -> [[Int]] {
    let diagramHeight = lines.map({ max($0.start.y, $0.end.y) }).max()!
    let diagramWidth = lines.map({ max($0.start.x, $0.end.x) }).max()!
    var diagram: [[Int]] = []

    for _ in 0 ... diagramHeight {
        var row: [Int] = []

        for _ in 0 ... diagramWidth {
            row.append(0)
        }

        diagram.append(row)
    }
    
    return diagram
}

private func update(_ diagram: inout [[Int]], using line: Line) {
    if (line.start.x == line.end.x) {
        for rowIndex in min(line.start.y, line.end.y) ... max(line.start.y, line.end.y) {
            diagram[rowIndex][line.start.x] += 1
        }
    } else if (line.start.y == line.end.y) {
        for columnIndex in min(line.start.x, line.end.x) ... max(line.start.x, line.end.x) {
            diagram[line.start.y][columnIndex] += 1
        }
    }
}

main()
