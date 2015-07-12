#import "RTFakeKeyChainWrapper.h"

@interface RTFakeKeyChainWrapper ()

@property NSMutableDictionary *items;

@end

@implementation RTFakeKeyChainWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id<NSSecureCoding>)objectForKey:(NSString *)key
                             error:(NSError *__autoreleasing *)error {
    NSData *encodedData = [self.items objectForKey:key];
    if (encodedData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return nil;
}

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error {
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self.items setObject:encodedData forKey:key];
    return YES;
}

- (BOOL)removeObjectForKey:(NSString *)key
                     error:(NSError *__autoreleasing *)error {
    [self.items removeObjectForKey:key];
    return YES;
}

@end
