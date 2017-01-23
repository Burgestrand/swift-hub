Original gist is here:

  https://gist.github.com/Burgestrand/575ee47fae55cba18d29f28227740a18

There's a blog post about this repository:

  https://www.burgestrand.se/articles/statically-typed-notificationcenter-in-swift/

And here's a usage example:

```swift
/*
 Statically declare all domain events, along with the type of extra information the
 event will carry with it.
 */
extension Events {
    static let userUpdated = Event<User?>("UserUpdated")
}

struct User {
    let name: String
}

let hub = Hub()

hub.observe(.userUpdated) { user in
    if let user = user {
        debugPrint("New user: \(user.name)")
    } else {
        debugPrint("User disappeared!")
    }
}

hub.post(.userUpdated, User(name: "alice@example.com"))
hub.post(.userUpdated, nil)
```

## Contributions

Pull requests are very welcome!

Some thoughts regarding possible changes or updates:

- We're using `object`, but perhaps `userInfo` is better with a known key?
- We don't allow specifying `object` in `observe` or `post`.
- We don't allow specifying `queue` in `observe`.
- There's no alternative with an observer that auto-cancels on deinit.
- There's no observe that observes just once.

## License

MIT license.
