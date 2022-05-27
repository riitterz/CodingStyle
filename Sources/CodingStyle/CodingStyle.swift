//
//  CodingStyle.swift
//  CodingStylePropertyWrapper
//
//  Created by Macbook on 27.05.2022.
//

import Foundation

@propertyWrapper
public struct CodingStyle {

    public enum CaseStyle {
        case snake,
             kebab,
             camel
    }
    
    public init(wrappedValue: String, coding: CaseStyle) {
        self.value = wrappedValue
        self.caseStyle = coding
    }
    

    private var value: String
    private let caseStyle: CaseStyle
    private static let codings: [CaseStyle: (String) -> String] = [
        .snake: { value in value.lowercased()
            .split(separator: " ")
            .drop { $0.isEmpty }
            .joined(separator: "_")
        },
        .kebab: { value in
            value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .joined(separator: "-")
        },
        .camel: { value in
            let value = value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .map { $0.prefix(1).uppercased()+$0.dropFirst() }
                .joined()
            return value.prefix(1).lowercased()+value.dropFirst()
        }
    ]

    private func get() -> String {
        guard let coding = CodingStyle.codings[caseStyle] else { return value }
        return coding(value)
    }

    private mutating func set(_ newValue: String) {
        value = newValue
    }

    public var wrappedValue: String {
        get {
            get()
        }
        set {
            set(newValue)
        }
    }
}
