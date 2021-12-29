#  TheSpoon

##Instructions
- Install Pods launching the command 'pod install' in the project root (where Podfile is placed).
- Compile and Run.

##Architecture
- A standard Clean Architecture implementation.
- Dependency Inversion is guaranteed by the Swinject library.
- UI defined programmatically (UIKit)
- Reactive framework: RxSwift and RxAlamofire (for networking).
- Local Storage using standard User Defaults. LocalStorageDataSourceInterface can be easily swapped with other kind of persistence strategies (Cloud, Firebase, Realm, etc)



