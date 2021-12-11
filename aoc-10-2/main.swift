//
//  main.swift
//  aoc-10-2
//
//  Created by Robertas on 2021-12-11.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

enum RuntimeErrors: Error {
    case invalidCharacterError
}

func main() throws {
    print("Advent Of Code 2021: Day 10 Quest 2")
    
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
            print("Total syntax error score: \(try totalSyntaxErrorScore(of: input))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func totalSyntaxErrorScore(of input: [String]) throws -> Int {
    let incompleteLineEnds = try input
        .filter({ try firstCorruptedChar(in: $0) == nil })
        .map({ try ending(of: $0) })

    let lineEndScores = incompleteLineEnds.map({ lineEnd in
        return lineEnd.reduce(into: 0) { result, char in
            result *= 5
            result += score(of: char)
        }
    })
    .sorted()
    
    return lineEndScores[lineEndScores.count / 2]
}

private func firstCorruptedChar(in line: String) throws -> Character? {
    var openChunks: [Character] = []

    for charIndex in 0 ..< line.utf8.count {
        let char = line[line.index(line.startIndex, offsetBy: charIndex)]
        
        if isOpening(char) {
            openChunks.append(char)
        } else if try opposite(for: char) == openChunks.last {
            openChunks.removeLast()
        } else {
            return char
        }
    }

    return nil
}

private func isOpening(_ char: Character) -> Bool {
    switch char {
    case "(", "[", "{", "<": return true
    default: return false
    }
}

private func opposite(for char: Character) throws -> Character {
    switch char {
    case ")": return "("
    case "]": return "["
    case "}": return "{"
    case ">": return "<"
    case "(": return ")"
    case "[": return "]"
    case "{": return "}"
    case "<": return ">"
    default: throw RuntimeErrors.invalidCharacterError
    }
}

private func ending(of line: String) throws -> String {
    var openChunks: [Character] = []

    for charIndex in 0 ..< line.utf8.count {
        let char = line[line.index(line.startIndex, offsetBy: charIndex)]
        
        if isOpening(char) {
            openChunks.append(char)
        } else if try opposite(for: char) == openChunks.last {
            openChunks.removeLast()
        }
    }

    return try String(openChunks.reversed().map({ try opposite(for: $0) }))
}

private func score(of char: Character) -> Int {
    switch char {
    case ")": return 1
    case "]": return 2
    case "}": return 3
    case ">": return 4
    default: return 0
    }
}

try main()
