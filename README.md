# MMMTweaks

Swift support for Facebook's Tweaks library.

(This is a part of `MMMTemple` suite of iOS libraries we use at [MediaMonks](https://www.mediamonks.com/).)

## Quick example

We're trying to keep the spirit of super convenience Tweak's ObjC macros. 

	import MMMTweaks
	
	// On startup:
	#if TWEAKS_ENABLED
	MMMTweaks.register()
	#endif
	
	// Anywhere in your code, but better closer to the use site:
	extension MMMTweaks {
		@objc static var shouldMockCookies: BoolTweak = {
			return BoolTweak(path: .init("Test", "Mocks", "Mock cookies"), defaultValue: false)
		}()
	}
	
	// Use site:
	if MMMTweaks.shouldMockCookies.isOn {
		// ...
	}

## Installation

Podfile:

```
source 'https://github.com/mediamonks/MMMSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
...
pod 'MMMTweaks'
```

---
