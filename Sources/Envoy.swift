import Foundation

/// A Swift-friendly generic replacement for NSNotificationCenter. Instead of relying on selectors this is purely based
/// on protocols and uses Swift generics to handle different protocols. This implementation does *not* retain observers
/// and thus there's no need to unregister in deinit method.
///

public class Envoy {
    
    fileprivate static var observersMap = [String: NSHashTable<AnyObject>]()
    fileprivate static let notificationQueue = DispatchQueue(label: "com.airhelp.envoy.queue", attributes: DispatchQueue.Attributes.concurrent)
    
    fileprivate init() {
    }
    
    /// Registers observer for notifications coming from given object. Note that observer is not retained and there's no
    /// need to call unregister. You can only use reference type objects for observation.
    ///
    /// - Parameter protocolType: Type of protocol you wish to use for registration
    /// - Parameter observer: Observer you wish to register for observation
    /// - Parameter object: object you wish to observer
    public static func register<T>(_ protocolType: T.Type, observer: T, object: AnyObject) {
        let key = notificationEntryKey(String(describing: protocolType), object: object)
        storeObserver(key, observer: observer as AnyObject)
    }
    
    
    /// Unregisters given observer. Please note that you *have* to pass the object that you've registered for.
    public static func unregister<T>(_ protocolType: T.Type, observer: T, object: AnyObject) {
        let key = notificationEntryKey(String(describing: protocolType), object: object)
        removeObserver(key, observer: observer as AnyObject)
    }
    
    
    /// This method is used to notify observers about events. You should use the passed in closure to call the
    /// right method.
    public static func notify<T>(_ protocolType: T.Type, object: AnyObject, closure: (_ observer: T) -> Void) {
        let key = notificationEntryKey(String(describing: protocolType), object: object)
        guard let observers = observersMap[key] else {
            return
        }
        
        for observer in observers.allObjects {
            if let observer = observer as? T {
                closure(observer)
            }
        }
    }
}

private extension Envoy {
    
    static func notificationEntryKey(_ protocolType: String, object: AnyObject) -> String {
        let objectHash = ObjectIdentifier(object).hashValue
        return "\(protocolType)-\(objectHash)"
    }
    
    static func storeObserver(_ key: String, observer: AnyObject) {
        notificationQueue.sync(flags: .barrier, execute: {
            let observers: NSHashTable<AnyObject>
            
            if let set = observersMap[key] {
                observers = set
            } else {
                observers = NSHashTable.weakObjects()
                observersMap[key] = observers
            }
            
            observers.add(observer)
        })
    }
    
    static func removeObserver(_ key: String, observer: AnyObject) {
        guard let observers = observersMap[key] else {
            print("[Envoy] Attempted to remove observer for key \(key), but no observers are registered with that key!")
            return
        }
        notificationQueue.sync(flags: .barrier, execute: {
            observers.remove(observer)
        })
    }
    
    static func observers<T:AnyObject>(_ key: String) -> [T] {
        
        var observers = [T]()
        
        notificationQueue.sync {
            if let actualObservers = observersMap[key]?.allObjects as? [T] {
                observers = actualObservers
            }
        }
        
        return observers
    }
}
