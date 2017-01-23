import class Foundation.NotificationCenter
import struct Foundation.Notification

/*
 Swift does not allow us to have static members of a generic class, which
 means we won't be able to use the dot short hand for any method that takes
 an Event<T> as parameter.
 However, we can work around this by having a superclass, `Events`, and then
 inherit it from it in our `Event<T>`. Any static members of `Events` will
 then be accepted as a dot short-hand for any `Event<T>` parameter.
 See http://radex.io/swift/nsuserdefaults/static/
 */
class Events {}
class Event<T>: Events {
    fileprivate let name: Notification.Name

    init(_ name: String) {
        self.name = Notification.Name(name)
    }
}

/*
 An implementation of our notification center.
 */
class Hub {
    struct Observer {
        fileprivate let center: NotificationCenter
        fileprivate var observer: Any?

        mutating func remove() {
            if let observer = observer {
                center.removeObserver(observer)
                self.observer = nil
            }
        }
    }

    let notificationCenter = NotificationCenter()

    /*
     Swift does not allow us to cast `nil as! T` above without encountering an unexpected unwrap of nil,
     so this reimplementation of `observe` allows us to broadcasts events of type T?.
     */
    @discardableResult
    func observe<T>(_ event: Event<T?>, callback: @escaping (T?) -> ()) -> Observer {
        return observe(event.name) { callback($0 as? T) }
    }

    @discardableResult
    func observe<T>(_ event: Event<T>, callback: @escaping (T) -> ()) -> Observer {
        return observe(event.name) { callback($0 as! T) }
    }

    fileprivate func observe(_ name: Notification.Name, block: @escaping (Any?) -> ()) -> Observer {
        let observer = notificationCenter.addObserver(forName: name, object: nil, queue: nil) { notification in
            block(notification.object)
        }

        return Observer(
            center: notificationCenter,
            observer: observer
        )
    }

    func post<T>(_ event: Event<T>, _ object: T) {
        notificationCenter.post(name: event.name, object: object)
    }

    func post<T>(_ event: Event<T?>, _ object: T?) {
        notificationCenter.post(name: event.name, object: object)
    }
}
