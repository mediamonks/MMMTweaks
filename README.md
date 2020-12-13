# MMMTweaks

Swift support for Facebook's Tweaks library.

(This is a part of `MMMTemple` suite of iOS libraries we use at [MediaMonks](https://www.mediamonks.com/).)

## Quick example

We're trying to keep the spirit of super convenience Tweak's ObjC macros. 

	import MMMTweaks
	
	// On startup:
	#if DEBUG // Or any other condition when you want to have Tweaks enabled.
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

Both the original Tweaks library and this Swift shim are by default enabled whenever `DEBUG` macro and `DEBUG` Swift active compilation conditions are correspondinly defined in their targets. 

To enable both libraries in configs where `DEBUG` is not defined you would need to define `FB_TWEAK_ENABLED` macro as `1` for Tweaks and add `FB_TWEAK_ENABLED` active compilation condition for MMMTweaks.

For example, you can enable both libs for non-Debug configs of your choice via a postinstall script in your Podfile:

	post_install do |installer|
		installer.pods_project.targets.each do |target|
			target.build_configurations.each do |config|
				if (target.name == "MMMTweaks" || target.name == "Tweaks") && (config.name == "<YourSpecialConfig>")
					config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
					config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'FB_TWEAK_ENABLED=1'
					config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] ||= ['$(inherited)']
					config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] << 'FB_TWEAK_ENABLED'
				end
			end
		end
	end


## Installation

Podfile:

```
source 'https://github.com/mediamonks/MMMSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
...
pod 'MMMTweaks'
```

---
