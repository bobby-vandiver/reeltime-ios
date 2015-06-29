#import "RTMutableArrayDataSource.h"
#import "RTSynchronizedMutableArray.h"

@interface RTMutableArrayDataSource ()

@property RTSynchronizedMutableArray *mutableItems;
@property (copy, nonatomic) OnDeleteCellBlock onDeleteCellBlock;

@end

@implementation RTMutableArrayDataSource

+ (instancetype)rowMajorArrayWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(ConfigureCellBlock)configureCellBlock
                     onDeleteCellBlock:(OnDeleteCellBlock)onDeleteCellBlock {

    RTMutableArrayDataSource *dataSource = [super rowMajorArrayWithItems:items
                                                          cellIdentifier:cellIdentifier
                                                      configureCellBlock:configureCellBlock];
    if (dataSource) {
        dataSource.onDeleteCellBlock = onDeleteCellBlock;
    }
    return dataSource;
}

- (NSArray *)items {
    return self.mutableItems;
}

- (void)setItems:(NSArray *)items {
    self.mutableItems = [items mutableCopy];
}

- (void)addItem:(id)item {
    [self.mutableItems addObject:item];
}

- (void)removeItemsPassingTest:(MatchItemTest)matchItemTest {
    NSIndexSet *indexSet = [self.mutableItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return matchItemTest(obj);
    }];
    [self.mutableItems removeObjectsAtIndexes:indexSet];
}

- (void)removeAllItems {
    [self.mutableItems removeAllObjects];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.onDeleteCellBlock && editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger idx = indexPath.row;
        NSObject *item = self.items[idx];

        id cell = [tableView cellForRowAtIndexPath:indexPath];
        self.onDeleteCellBlock(cell, item);
    }
}

@end
