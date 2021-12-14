//
//  main.swift
//  aoc-14-1
//
//  Created by Robertas on 2021-12-14.
//  Copyright © 2021 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2021: Day 14 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?
            .components(separatedBy: "\n\n")
            .filter({ !$0.isEmpty })
        {
            let startTimestamp = Date().timeIntervalSince1970
            print("Quantity of the most common element subtracted by the quantity of the least common element: \(result(of: input))")
            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func result(of input: [String]) -> Int {
    let pairInsertionRules = input[1].components(separatedBy: "\n").map({ $0.components(separatedBy: " -> ")})
    var polymerTemplate = input[0]
    let elements: Set<Character> = distinctElements(in: pairInsertionRules, and: polymerTemplate)

    for _ in 0 ..< 10 {
        var templateParts: [[[Character]]] = parts(of: polymerTemplate).map({ [$0] })

        for partIndex in 0 ..< templateParts.count {
            let part = String(templateParts[partIndex][0])

            if let matchingRule = pairInsertionRules.first(where: { String(part) == $0[0]}) {
                let lastPart = templateParts[partIndex][0][1]

                templateParts[partIndex][0] = [templateParts[partIndex][0][0], matchingRule[1][matchingRule[1].startIndex]]
                
                if partIndex == templateParts.count - 1 {
                    templateParts[partIndex][0].append(lastPart)
                }
            }
        }
        
        polymerTemplate = updated(polymerTemplate, using: pairInsertionRules)
    }

    let occurenceAmounts: [Int] = elements.map { element in
        polymerTemplate.filter({ $0 == element }).count
    }

    return occurenceAmounts.max()! - occurenceAmounts.min()!
}

private func parts(of template: String) -> [[Character]] {
    return (0 ..< template.utf8.count - 1).map({ index -> [Character] in
        let firstCharIndex = template.index(template.startIndex, offsetBy: index)
        let secondCharIndex = template.index(template.startIndex, offsetBy: index + 1)
        return [template[firstCharIndex], template[secondCharIndex]]
    })
}

private func distinctElements(in pairInsertionRules: [[String]], and polymerTemplate: String) -> Set<Character> {
    var elements: Set<Character> = []

    polymerTemplate.forEach({ character in
        elements.insert(character)
    })
    
    pairInsertionRules.forEach({ rule in
        rule.forEach({ rulePart in
            rulePart.forEach({ elements.insert($0) })
        })
    })

    return elements
}

private func updated(_ polymerTemplate: String, using pairInsertionRules: [[String]]) -> String {
    var templateParts: [[[Character]]] = parts(of: polymerTemplate).map({ [$0] })

    for partIndex in 0 ..< templateParts.count {
        let part = String(templateParts[partIndex][0])

        if let matchingRule = pairInsertionRules.first(where: { part == $0[0]}) {
            let lastPart = templateParts[partIndex][0][1]

            templateParts[partIndex][0] = [templateParts[partIndex][0][0], matchingRule[1][matchingRule[1].startIndex]]
            
            if partIndex == templateParts.count - 1 {
                templateParts[partIndex][0].append(lastPart)
            }
        }
    }
    
    return String(templateParts.map({ $0.joined() }).joined())
}

main()
