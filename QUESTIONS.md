# BreakingRealBad
An example project using Breaking Bad API

## Questions

#### 1. What (if any) further additions would you like to make to your submission if you had more time?

- Would love to have improved UI (change layout) and navigation animations with SwiftUI like match geometry effect
- `Pagination` of all characters, it quite heavy to fetch a lot of this data upfront, we can mitigate this with pagination.
- Add `Haptics` feedback when pressing buttons or when data is loaded successfully or with error
- Add `Snapshot tests` of the screens
- Better error handling messages
- Have a `Launch Screen` of the app
- Figure out a consistent way to use the `The Composable Architecture` and at the same time not compromise of best practices like clean architecture (for dependency rule), Solid Principles (for reusability, scalability, separation of concerns etc...)

#### 2. Is there anything you would change about your current implementation?
- Change Core Data with another persistence mechanism, maybe use UserDefaults since the data stored is non-sensitive and lightweight. as well as in memory
- More testing especially the CoraData layer, mocking `NSManagedObjectContext` and then using it to test relevant parts of `CharacterRepository`
