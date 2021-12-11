//
//  main.swift
//  aoc-10-1
//
//  Created by Robertas on 2021-12-11.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

enum RuntimeErrors: Error {
    case invalidCharacterError
}

func main() throws {
    print("Advent Of Code 2021: Day 10 Quest 1")
    
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
    return try input
        .compactMap({ try firstCorruptedChar(in: $0) })
        .reduce(into: 0) { result, char in
            switch char {
            case ")": result += 3
            case "]": result += 57
            case "}": result += 1197
            case ">": result += 25137
            default: throw RuntimeErrors.invalidCharacterError
            }
        }
}

private func firstCorruptedChar(in line: String) throws -> Character? {
    var openChunks: [Character] = []

    for charIndex in 0 ..< line.utf8.count {
        let char = line[line.index(line.startIndex, offsetBy: charIndex)]
        
        if isOpening(char) {
            openChunks.append(char)
        } else if try opening(for: char) == openChunks.last {
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

private func opening(for char: Character) throws -> Character {
    switch char {
    case ")": return "("
    case "]": return "["
    case "}": return "{"
    case ">": return "<"
    default: throw RuntimeErrors.invalidCharacterError
    }
}

try main()
