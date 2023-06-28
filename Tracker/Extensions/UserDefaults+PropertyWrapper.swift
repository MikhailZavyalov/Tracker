import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
        }
        set {
            if newValue == nil {
                return UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
