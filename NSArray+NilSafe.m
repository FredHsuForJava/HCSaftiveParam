//
//  NSArray+NilSafe.m
//  HealthCloud
//
//  Created by 许文锋 on 2020/9/12.
//  Copyright © 2020 www.bsoft.com. All rights reserved.
//

#import "NSArray+NilSafe.h"
#import <objc/runtime.h>


@implementation NSObject (Swizzling)

+ (BOOL)gl_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
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

+ (BOOL)gl_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) gl_swizzleMethod:origSel withMethod:altSel];
}

@end


@implementation NSArray (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self gl_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(gl_initWithObjects:count:)];
        [self gl_swizzleClassMethod:@selector(arrayWithObjects:count:) withMethod:@selector(gl_arrayWithObjects:count:)];
        [self gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(gl_objectAtIndex:)];
    });
}

- (instancetype)gl_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    if (cnt == 0) {
        return [self gl_initWithObjects:objects  count:cnt];
    }
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        if (!obj) {
            obj = [NSNull null];
        }
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_initWithObjects:safeObjects  count:j];
}

+ (instancetype)gl_arrayWithObjects:(const id [])objects  count:(NSUInteger)cnt {
    if (cnt == 0) {
        return [self gl_arrayWithObjects:objects  count:cnt];
    }
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        if (!obj) {
            continue;
        }
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_arrayWithObjects:safeObjects  count:j];
}

- (instancetype)gl_objectAtIndex:(NSUInteger)index{
    if(index<[self count]){
        return [self gl_objectAtIndex:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}

@end

@implementation NSMutableArray (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArrayM");
        [class gl_swizzleMethod:@selector(addObject:) withMethod:@selector(gl_addObject:)];
        [class gl_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(gl_insertObject:atIndex:)];
    });
}

- (void)gl_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self gl_addObject:anObject];
}

- (void)gl_insertObject:(id)obj atIndex:(NSUInteger)index {
    if (!obj) {
        return;
    }
    [self gl_insertObject:obj atIndex:index];
}


@end
