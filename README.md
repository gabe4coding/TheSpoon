#  TheSpoon

## Instructions
- Install Pods launching the command 'pod install' in the project root (where Podfile is placed).
- Compile and Run.

## Architecture
- A standard **Clean Architecture** implementation *(Presentation < - > Domain < - > Data )*
- **Dependency Inversion** is guaranteed by the **Swinject** library.
- UI defined programmatically (UIKit since SwiftUI is available from iOS13, and somehow stable from iOS14)
- Reactive framework: **RxSwift** and **RxAlamofire** (for networking).
- Local Storage using standard User Defaults. LocalStorageDataSourceInterface can be easily swapped with other kind of persistence strategies (Cloud, Firebase, Realm, etc)

## Considerations
- Since i've worked in the last year and half only with **SwiftUI** and **Combine**, it took sometime to come back on UIKit and Rx, and moreover i had the opportunity to completely avoid to use Storyboards/xibs, which gives much more control on the UI in my optinion.
- I didn't had much time to think and implement new features or implement Unit Tests unfortunately :(

## Changelog

### v1.0.4 
- Implemented Unit Tests

### v1.0.3
- Fixed crash on iPad for missing support on popover menu.

### v1.0.2
- Fixed wrong image status for favourite button. 

### v1.0.1
- Moved mapping of RestaurantModel from UseCase to ViewModel
- Code Refactor

### v1.0.0
- Release


