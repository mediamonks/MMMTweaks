//
// MMMTemple.
// Copyright (C) 2019 MediaMonks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Makes it more convenient to register tweakable values with Tweaks library and access them in Swift.
 *
 * `FBTweakValue` macro is not available in Swift, so this is an attempt to make something that still allows to define
 * tweakable values closer to the code using them.
 *
 * Note that the Swift part of this pod expects `TWEAKS_ENABLED` "compilation condition" to be set on the pod itself.
 * By default it is enabled for `Debug` configuration only, so if you have something else, like `Beta`, then you'll
 * need to adjust it in a corresponding post-install step of your `Podfile`.
 *
 * To add a tweak you should extend `MMMTweaks` with a static ObjC property returning one of the subclasses of
 * `MMMTweak`, like `MMMBoolTweak` (`MMMTweaks.BoolTweak` in Swift). This property can be then used by your own code
 * to get the current value of the tweak and also by this helper to register this tweak. `MMMTweaks` uses Obj-C
 * reflection to collect all these definitions early enough (when it's static `register` method is called) and feed
 * them to Tweaks.
 *
 * Example:
 *
 * \code
 * extension MMMTweaks {
 *     @objc static var shouldAlwaysMockDevices: BoolTweak = {
 *         BoolTweak(
 *             path: .init("Core", "Misc", "Always mock devices"),
 *             defaultValue: true
 *         )
 *     }()
 * }
 * \endcode
 */
@interface MMMTweaks : NSObject

/**
 * Registers all available tweakable values defined on the extensions of this class with Tweaks.
 *
 * Should be called on startup. Does not need to be called in Tweaks-free version of the app.
 */
+ (void)register;

@end

/** Describes where a tweakable value should appear in the Tweaks UI. */
NS_SWIFT_NAME(MMMTweaks.Path)
@interface MMMTweakPath : NSObject

@property (nonatomic, readonly) NSString *category;

/** Known as "collection name" in Tweaks, but I find it hard to remember if a collection is a part of a category
 * or vise versa. */
@property (nonatomic, readonly) NSString *subcategory;

@property (nonatomic, readonly) NSString *name;

- (id)initWithCategory:(NSString *)category
	subcategory:(NSString *)subcategory
	name:(NSString *)name NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(_:_:_:));

- (id)init NS_UNAVAILABLE;

@end

/**
 * Custom properties defined in extensions on `MMMTweak` should return subclasses of this.
 * Don't create instances of this directly.
 */
NS_SWIFT_UNAVAILABLE("")
@interface MMMTweak : NSObject

/// Where this tweak should land in the UI. Might be nil for disabled tweaks.
@property (nonatomic, readonly, nullable) MMMTweakPath *path;

- (id)init NS_UNAVAILABLE;

// The actual initializer is available only for subclasses.

@end

/** A tweakable boolean value. */
NS_SWIFT_NAME(MMMTweaks.BoolTweak)
@interface MMMBoolTweak : MMMTweak

@property (nonatomic, readonly) BOOL defaultValue NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly, getter=isOn) BOOL on;

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(BOOL)defaultValue
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

/** A tweakable string value. */
NS_SWIFT_NAME(MMMTweaks.StringTweak)
@interface MMMStringTweak : MMMTweak

@property (nonatomic, readonly) NSString *defaultValue NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) NSString *value;

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(NSString *)defaultValue
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

/** A tweakable long (int in swift) value. */
NS_SWIFT_NAME(MMMTweaks.IntTweak)
@interface MMMLongTweak : MMMTweak

@property (nonatomic, readonly) long defaultValue NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) long value;

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(long)defaultValue
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

/** A tweakable double value. */
NS_SWIFT_NAME(MMMTweaks.DoubleTweak)
@interface MMMDoubleTweak : MMMTweak

@property (nonatomic, readonly) double defaultValue NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) double value;

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(double)defaultValue
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

/** A tweak calling direct action when tapped. */
NS_SWIFT_NAME(MMMTweaks.ActionTweak)
@interface MMMActionTweak : MMMTweak

@property (nonatomic, readonly) void (^block)(void);

- (id)initWithPath:(nullable MMMTweakPath *)path
			 block: (void (^_Nullable)(void))block
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

@class MMMEnumTweakChoice;

/** A tweakable value with a fixed number of possible choices. */
NS_SWIFT_NAME(MMMTweaks.EnumTweak)
@interface MMMEnumTweak : MMMTweak

@property (nonatomic, readonly) id defaultValue NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) id value;

@property (nonatomic, readonly, nullable) NSArray<MMMEnumTweakChoice *> *choices NS_SWIFT_UNAVAILABLE("");

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(id)defaultValue
	choices:(nullable NSArray<MMMEnumTweakChoice *> *)choices
	NS_DESIGNATED_INITIALIZER
	NS_REFINED_FOR_SWIFT;

@end

NS_SWIFT_NAME(MMMTweaks.EnumTweakChoice)
@interface MMMEnumTweakChoice : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) id value;

- (id)initWithValue:(id)value
	title:(NSString *)title NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

