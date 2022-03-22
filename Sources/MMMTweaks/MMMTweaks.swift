//
// MMMTemple.
// Copyright (C) 2019 MediaMonks. All rights reserved.
//

#if SWIFT_PACKAGE
import MMMTweaksObjC

@_exported import MMMTweaksObjC
#endif

extension MMMTweaks.BoolTweak {

	/// Swift-specific initializer allows to use autoclosures to keep only the default value in Tweaks-free version
	/// of the app.
	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		defaultValue: Bool
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), defaultValue: defaultValue)
		#else
			self.init(__path: nil, defaultValue: defaultValue)
		#endif
	}
}

extension MMMTweaks.StringTweak {

	/// Swift-specific initializer allows to use autoclosures to keep only the default value in Tweaks-free version
	/// of the app.
	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		defaultValue: String
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), defaultValue: defaultValue)
		#else
			self.init(__path: nil, defaultValue: defaultValue)
		#endif
	}
}

extension MMMTweaks.IntTweak {

	/// Swift-specific initializer allows to use autoclosures to keep only the default value in Tweaks-free version
	/// of the app.
	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		defaultValue: Int
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), defaultValue: defaultValue)
		#else
			self.init(__path: nil, defaultValue: defaultValue)
		#endif
	}
}

extension MMMTweaks.DoubleTweak {

	/// Swift-specific initializer allows to use autoclosures to keep only the default value in Tweaks-free version
	/// of the app.
	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		defaultValue: Double
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), defaultValue: defaultValue)
		#else
			self.init(__path: nil, defaultValue: defaultValue)
		#endif
	}
}

/*
- I was inconvenient to make `EnumTweak` generic over its value in Obj-C as it would be inconvenient to use in Swift
(require using `NSString`, etc).

- It was not possible to use a Swift subclass of `EnumTweak` that would be generic over the value as well, because
it would not be able to be used with an Obj-C property which every tweak value has to be now for registration
purposes.

- I wanted to have at least the initializer generic over default value the values in choices, but was getting
segmentation faults in the compiler. Should try later.
*/
extension MMMTweaks.EnumTweak {

	/// Swift-specific initializer allows to use autoclosures to keep only the default value in Tweaks-free version
	/// of the app.
	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		defaultValue: Any,
		choices: @autoclosure () -> [MMMTweaks.EnumTweakChoice]
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), defaultValue: defaultValue, choices: choices())
		#else
			self.init(__path: nil, defaultValue: defaultValue, choices: nil)
		#endif
	}
}

extension MMMTweaks.ActionTweak {

	public convenience init(
		path: @autoclosure () -> MMMTweaks.Path,
		block: @escaping () -> Void
	) {
		#if DEBUG || FB_TWEAK_ENABLED
			self.init(__path: path(), block: block)
		#else
			self.init(__path: nil, block: nil)
		#endif
	}
}
