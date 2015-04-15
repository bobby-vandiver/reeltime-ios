#import "RTMutableArrayDataSource.h"
#import "RTSynchronizedMutableArray.h"

@interface RTMutableArrayDataSource ()

@property RTSynchronizedMutableArray *mutableItems;

@end

@implementation RTMutableArrayDataSource

- (NSArray *)items {
    return self.mutableItems;
}

- (void)setItems:(NSArray *)items {
    self.mutableItems = [items mutableCopy];
}

- (void)addItem:(id)item {
    [self.mutableItems addObject:item];
}

- (void)removeAllItems {
    [self.mutableItems removeAllObjects];
}

@end
