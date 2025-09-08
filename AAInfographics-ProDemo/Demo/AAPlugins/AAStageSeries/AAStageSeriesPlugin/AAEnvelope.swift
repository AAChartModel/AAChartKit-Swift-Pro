import Foundation

public class AAEnvelope: AAObject {
    public var mode: String?
    public var arcs: Bool?
    public var arcsMode: String?
    public var gapConnect: Float?
    public var margin: Float?
    public var externalRadius: Float?
    public var opacity: Float?
    public var seamEpsilon: Float?
    public var connectorTrim: Float?
    public var shadow: AAShadow?
    public var color: Any?

    @discardableResult
    public func mode(_ prop: String?) -> AAEnvelope {
        mode = prop
        return self
    }

    @discardableResult
    public func arcs(_ prop: Bool?) -> AAEnvelope {
        arcs = prop
        return self
    }

    @discardableResult
    public func arcsMode(_ prop: String?) -> AAEnvelope {
        arcsMode = prop
        return self
    }

    @discardableResult
    public func gapConnect(_ prop: Float?) -> AAEnvelope {
        gapConnect = prop
        return self
    }

    @discardableResult
    public func margin(_ prop: Float?) -> AAEnvelope {
        margin = prop
        return self
    }

    @discardableResult
    public func externalRadius(_ prop: Float?) -> AAEnvelope {
        externalRadius = prop
        return self
    }

    @discardableResult
    public func opacity(_ prop: Float?) -> AAEnvelope {
        opacity = prop
        return self
    }

    @discardableResult
    public func seamEpsilon(_ prop: Float?) -> AAEnvelope {
        seamEpsilon = prop
        return self
    }

    @discardableResult
    public func connectorTrim(_ prop: Float?) -> AAEnvelope {
        connectorTrim = prop
        return self
    }

    @discardableResult
    public func shadow(_ prop: AAShadow?) -> AAEnvelope {
        shadow = prop
        return self
    }
    
    @discardableResult
    public func color(_ prop: Any?) -> AAEnvelope {
        color = prop
        return self
    }

    public override init() {

    }
}
