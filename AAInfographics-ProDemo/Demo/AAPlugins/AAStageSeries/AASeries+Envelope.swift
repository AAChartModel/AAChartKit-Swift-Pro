import Foundation

public extension AASeries {
    private struct AssociatedKeys {
        static var envelope: UInt8 = 0
    }

    var envelope: AAEnvelope? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.envelope) as? AAEnvelope
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.envelope, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    func envelope(_ prop: AAEnvelope?) -> Self {
        envelope = prop
        return self
    }
}


//遵循协议以提供计算属性
extension AASeries: AASerializableWithComputedProperties {
    public func computedProperties() -> [String: Any] {
//        return [
//            "drilldown": drilldown?.toDic() as Any,
//            "boost": boost?.toDic() as Any
//        ]
        var dict = [String: Any]()
        if envelope != nil {
            dict["envelope"] = envelope?.toDic() as Any
        }
        
        return dict
    }
}
