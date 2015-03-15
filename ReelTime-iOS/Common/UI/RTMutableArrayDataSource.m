#import "RTMutableArrayDataSource.h"

@interface RTMutableArrayDataSource ()

@property NSMutableArray *mutableItems;

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
