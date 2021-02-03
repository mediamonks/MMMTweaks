//
// MMMTemple.
// Copyright (C) 2019 MediaMonks. All rights reserved.
//

#import "MMMTweaks.h"

#import <objc/runtime.h>

@import Tweaks;

//
//
//
@implementation MMMTweakPath

- (id)initWithCategory:(NSString *)category
	subcategory:(NSString *)subcategory
	name:(NSString *)name
{
	if (self = [super init]) {
		_category = category;
		_subcategory = subcategory;
		_name = name;
	}

	return self;
}

@end

//
// Things for friends only.
//
@interface MMMTweak ()

- (id)initWithPath:(nullable MMMTweakPath *)descriptor;

@property (nonatomic, readwrite) FBTweak *fbTweak;

@end

@implementation MMMTweak

- (id)initWithPath:(MMMTweakPath *)path {

	if (self = [super init]) {
		_path = path;
	}

	return self;
}

@end

//
//
//
@implementation MMMBoolTweak {
	BOOL _defaultValue;
}

- (BOOL)isOn {
	return self.fbTweak.currentValue ? [self.fbTweak.currentValue boolValue] : _defaultValue;
}

- (id)initWithPath:(nullable MMMTweakPath *)path defaultValue:(BOOL)defaultValue {
	if (self = [super initWithPath:path]) {
		_defaultValue = defaultValue;
	}
	return self;
}

@end

//
//
//
@implementation MMMStringTweak {
	NSString *_defaultValue;
}

- (NSString *)value {
	return self.fbTweak.currentValue ?: _defaultValue;
}

- (id)initWithPath:(MMMTweakPath *)path defaultValue:(NSString *)defaultValue {
	if (self = [super initWithPath:path]) {
		_defaultValue = defaultValue;
	}
	return self;
}

@end

//
//
//
@implementation MMMLongTweak {
	long _defaultValue;
}

- (long)value {
	return self.fbTweak.currentValue ? [self.fbTweak.currentValue longValue] : _defaultValue;
}

- (id)initWithPath:(MMMTweakPath *)path defaultValue:(long)defaultValue {
	if (self = [super initWithPath:path]) {
		_defaultValue = defaultValue;
	}
	return self;
}

@end

//
//
//
@implementation MMMDoubleTweak {
	double _defaultValue;
}

- (double)value {
	return self.fbTweak.currentValue ? [self.fbTweak.currentValue doubleValue] : _defaultValue;
}

- (id)initWithPath:(MMMTweakPath *)path defaultValue:(double)defaultValue {
	if (self = [super initWithPath:path]) {
		_defaultValue = defaultValue;
	}
	return self;
}

@end

//
//
//
@implementation MMMEnumTweak {
	id _defaultValue;
}

- (id<NSCopying>)value {
	return self.fbTweak.currentValue ?: _defaultValue;
}

- (id)initWithPath:(nullable MMMTweakPath *)path
	defaultValue:(id)defaultValue
	choices:(nullable NSArray<MMMEnumTweakChoice *> *)choices
{
	if (self = [super initWithPath:path]) {
		_defaultValue = defaultValue;
		_choices = choices;
	}
	
	return self;
}

@end

//
//
//

@implementation MMMEnumTweakChoice

- (id)initWithValue:(id)value title:(NSString *)title {
	if (self = [super init]) {
		_title = title;
		_value = value;
	}
	return self;
}

@end

//
//
//
@implementation MMMActionTweak {
	void (^_block)(void);
}

- (id)initWithPath:(MMMTweakPath *)path block:(void (^)(void))block {
	if (self = [super initWithPath:path]) {
		_block = block;
	}
	return self;
}

@end


//
//
//
@implementation MMMTweaks

+ (void)register {

	static BOOL registered = NO;

	if (registered) {
		NSAssert(NO, @"Called %@#%s more than once", self, sel_getName(_cmd));
		return;
	}

	registered = YES;

	unsigned int methodCount = 0;
	Method *methods = class_copyMethodList(object_getClass(self), &methodCount);
	for (int i = 0; i < methodCount; i++) {

		struct objc_method_description *desc = method_getDescription(methods[i]);

		// TODO: we should be ignoring numbers in the signature as they might change.
		if (strcmp(desc->types, "@16@0:8") == 0) {

			const char *name = sel_getName(desc->name);

			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			id result = [self performSelector:desc->name];
			#pragma clang diagnostic pop

			if ([result isKindOfClass:[MMMTweak class]]) {
				[self registerTweak:result methodName:name];
			} else {
				NSAssert(NO, @"%@#%s() returned something different from %@", self, name, [MMMTweak class]);
			}
		}
	}
}

+ (void)registerTweak:(MMMTweak *)tweak methodName:(const char *)methodName {

	//~ NSLog(@"MMMTweaks: %s", methodName);

	MMMTweakPath *path = tweak.path;
	if (!path) {
		// Probably one part compiled with Tweaks-free settings and another still tries to register them.
		return;
	}

	// Note that we can assume that method names are unique and thus use only them for identifiers.
	// This way the actual name can be changed later without resetting the corresponding tweak.
	FBTweak *fbTweak = [[FBTweak alloc] initWithIdentifier:[NSString stringWithFormat:@"MMMTweak:%s", methodName]];
	fbTweak.name = path.name;

	if ([tweak isKindOfClass:[MMMBoolTweak class]]) {

		MMMBoolTweak *boolTweak = (MMMBoolTweak *)tweak;
		fbTweak.defaultValue = @(boolTweak.defaultValue);

	} else if ([tweak isKindOfClass:[MMMStringTweak class]]) {

		MMMStringTweak *stringTweak = (MMMStringTweak *)tweak;
		fbTweak.defaultValue = stringTweak.defaultValue;
		
	} else if ([tweak isKindOfClass:[MMMLongTweak class]]) {

		MMMLongTweak *longTweak = (MMMLongTweak *)tweak;
		fbTweak.defaultValue = @(longTweak.defaultValue);

	} else if ([tweak isKindOfClass:[MMMDoubleTweak class]]) {

		MMMDoubleTweak *doubleTweak = (MMMDoubleTweak *)tweak;
		fbTweak.defaultValue = @(doubleTweak.defaultValue);

	} else if ([tweak isKindOfClass:[MMMEnumTweak class]]) {

		MMMEnumTweak *enumTweak = (MMMEnumTweak *)tweak;

		NSMutableDictionary *possibleValues = [[NSMutableDictionary alloc] init];
		for (MMMEnumTweakChoice *c in enumTweak.choices) {
			NSAssert(possibleValues[c.value] == nil, @"An enum tweak has a duplicate choice");
			possibleValues[c.value] = c.title;
		}
		fbTweak.possibleValues = possibleValues;

		fbTweak.defaultValue = enumTweak.defaultValue;

	} else if ([tweak isKindOfClass:[MMMActionTweak class]]) {

		MMMActionTweak *actionTweak = (MMMActionTweak *)tweak;

		fbTweak.defaultValue = actionTweak.block;

	} else {
		NSAssert(NO, @"Tweaks of type %@ are not supported", tweak.class);
		return;
	}

	tweak.fbTweak = fbTweak;

	FBTweakCategory *category = [[FBTweakStore sharedInstance] tweakCategoryWithName:path.category];
	if (!category) {
		category = [[FBTweakCategory alloc] initWithName:path.category];
		[[FBTweakStore sharedInstance] addTweakCategory:category];
	}

	FBTweakCollection *collection = [category tweakCollectionWithName:path.subcategory];
	if (!collection) {
		collection = [[FBTweakCollection alloc] initWithName:path.subcategory];
		[category addTweakCollection:collection];
	}

	[collection addTweak:fbTweak];
}

@end
