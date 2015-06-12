#import "RTArrayDataSource.h"

@interface RTMutableArrayDataSource : RTArrayDataSource

- (void)addItem:(id)item;

- (void)removeItemsPassingTest:(MatchItemTest)matchItemTest;

- (void)removeAllItems;

@end
