ReelTime: iOS Client
====================

The iOS client for [ReelTime](https://github.com/bobby-vandiver/reeltime).

This project is provided as-is, programmer art and all.

Technical Notes
---------------

The architecture is an attempt to implement the [VIPER architecture](https://www.objc.io/issues/13-architecture/viper/).
The application is divided into "Use Cases". Each use case is broken up into the components outlined for VIPER plus one
component that contains the dependency injection "glue" for [Typhoon](https://github.com/appsquickly/Typhoon).
