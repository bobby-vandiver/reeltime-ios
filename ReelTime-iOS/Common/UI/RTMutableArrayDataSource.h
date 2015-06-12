#import "RTArrayDataSource.h"

typedef BOOL (^MatchItemTest)(id item);

@interface RTMutableArrayDataSource : RTArrayDataSource

- (void)addItem:(id)item;

- (void)removeItemsPassingTest:(MatchItemTest)matchItemTest;

- (void)removeAllItems;

@end
