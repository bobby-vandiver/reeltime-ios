#import "RTArrayDataSource.h"

@implementation RTArrayDataSource

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock
{
    return [self initWithItems:items
                cellIdentifier:cellIdentifier
            configureCellBlock:configureCellBlock
            useRowToSelectItem:YES];
}

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock
           useRowToSelectItem:(BOOL)useRowToSelectItem
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.useRowToSelectItem = useRowToSelectItem;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        NSInteger idx = self.useRowToSelectItem ? indexPath.row : indexPath.section;
        NSObject *item = self.items[idx];
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

@end
