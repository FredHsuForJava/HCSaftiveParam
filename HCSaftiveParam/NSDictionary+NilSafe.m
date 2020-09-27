//
//  NSDictionary+NilSafe.m
//  NSDictionary-NilSafe
//
//  Created by Allen Hsu on 6/22/16.
//  Copyright © 2016 Glow Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "NSDictionary+NilSafe.h"

@implementation NSObject (Swizzling)

+ (BOOL)hc_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)hc_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) hc_swizzleMethod:origSel withMethod:altSel];
}

@end

@implementation NSDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hc_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(hc_initWithObjects:forKeys:count:)];
        [self hc_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(hc_dictionaryWithObjects:forKeys:count:)];
    });
}

- (instancetype)hc_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    if (cnt == 0) {
        return  [self hc_initWithObjects:objects forKeys:keys count:cnt];
    }
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self hc_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

+ (instancetype)hc_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    if (cnt == 0) {
        return [self hc_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self hc_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}



@end

@implementation NSMutableDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class hc_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(hc_setObject:forKey:)];
        [class hc_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(hc_setObject:forKeyedSubscript:)];
    });
}

- (void)hc_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
        return;
    }
    [self hc_setObject:anObject forKey:aKey];
}

- (void)hc_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key || !obj) {
        return;
    }
    [self hc_setObject:obj forKeyedSubscript:key];
}

@end
