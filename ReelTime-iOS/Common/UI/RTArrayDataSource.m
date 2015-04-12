#import "RTArrayDataSource.h"

@implementation RTArrayDataSource

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
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
        NSInteger idx = indexPath.row;
        NSObject *item = self.items[idx];
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

@end
