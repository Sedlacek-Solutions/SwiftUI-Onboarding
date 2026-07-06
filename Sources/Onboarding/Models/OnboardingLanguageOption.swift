//
//  OnboardingLanguageOption.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import Foundation

public struct OnboardingLanguageOption: Identifiable, Hashable, Sendable {
    public let identifier: String
    public let displayName: String
    public let flag: String?
    public let shortName: String

    public var id: String {
        identifier
    }

    public init(
        identifier: String,
        displayName: String,
        flag: String? = nil,
        shortName: String? = nil
    ) {
        self.identifier = identifier
        self.displayName = displayName
        self.flag = flag
        self.shortName = shortName ?? identifier.prefix(2).uppercased()
    }
}
