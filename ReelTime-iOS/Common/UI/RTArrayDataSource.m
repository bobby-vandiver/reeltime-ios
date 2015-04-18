#import "RTArrayDataSource.h"

@interface RTArrayDataSource ()

@property BOOL rowMajor;

@end

@implementation RTArrayDataSource

+ (instancetype)rowMajorArrayWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    
    return [[self alloc] initWithItems:items
                        cellIdentifier:cellIdentifier
                    configureCellBlock:configureCellBlock
                              rowMajor:YES];
}

+ (instancetype)sectionMajorArrayWithItems:(NSArray *)items
                            cellIdentifier:(NSString *)cellIdentifier
                        configureCellBlock:(ConfigureCellBlock)configureCellBlock {

    return [[self alloc] initWithItems:items
                        cellIdentifier:cellIdentifier
                    configureCellBlock:configureCellBlock
                              rowMajor:NO];
}

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock
                     rowMajor:(BOOL)rowMajor
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.rowMajor = rowMajor;
     }
    return self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfItems];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    return [self configureCell:cell forItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfItems];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self numberOfSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    return [self configureCell:cell forItemAtIndexPath:indexPath];
}

#pragma mark - Common

- (NSInteger)numberOfItems {
    return self.rowMajor ? [self.items count] : 1;
}

- (NSInteger)numberOfSections {
    return self.rowMajor ? 1 : [self.items count];
}

- (id)configureCell:(id)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.configureCellBlock) {
        NSInteger idx = indexPath.row;
        NSObject *item = self.items[idx];
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

@end
