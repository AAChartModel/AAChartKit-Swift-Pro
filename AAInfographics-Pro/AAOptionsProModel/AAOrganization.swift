//
//  AAOrganization.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/23.
//

public class AAOrganization: AAObject {
    public var hangingIndentTranslation: String?
    public var hangingIndent: Float?

    @discardableResult
    public func hangingIndentTranslation(_ prop: String?) -> AAOrganization {
        hangingIndentTranslation = prop
        return self
    }

    @discardableResult
    public func hangingIndent(_ prop: Float?) -> AAOrganization {
        hangingIndent = prop
        return self
    }

}
