#import "RTArrayDataSource.h"

typedef void (^OnDeleteCellBlock)(id cell, id object);

@interface RTMutableArrayDataSource : RTArrayDataSource

+ (instancetype)rowMajorArrayWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(ConfigureCellBlock)configureCellBlock
                     onDeleteCellBlock:(OnDeleteCellBlock)onDeleteCellBlock;

- (void)addItem:(id)item;

- (void)removeItemsPassingTest:(MatchItemTest)matchItemTest;

- (void)removeAllItems;

@end
