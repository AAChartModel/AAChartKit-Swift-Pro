//
//  AAPictorial.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/23.
//

public class AAPictorial: AAObject {

    public var pointPadding: Float?
    public var groupPadding: Float?
    public var dataLabels: AADataLabels?
    public var stacking: String?
    public var paths: [AAPathsElement]?

    @discardableResult
    public func pointPadding(_ value: Float?) -> AAPictorial {
        self.pointPadding = value
        return self
    }

    @discardableResult
    public func groupPadding(_ value: Float?) -> AAPictorial {
        self.groupPadding = value
        return self
    }

    @discardableResult
    public func dataLabels(_ value: AADataLabels?) -> AAPictorial {
        self.dataLabels = value
        return self
    }

    @discardableResult
    public func stacking(_ value: String?) -> AAPictorial {
        self.stacking = value
        return self
    }

    @discardableResult
    public func paths(_ value: [AAPathsElement]?) -> AAPictorial {
        self.paths = value
        return self
    }

}


public class AAPathsElement: AAObject {

    public var definition: String?
    public var max: Float?

    @discardableResult
    public func definition(_ value: String?) -> AAPathsElement {
        self.definition = value
        return self
    }

    @discardableResult
    public func max(_ value: Float?) -> AAPathsElement {
        self.max = value
        return self
    }

}
