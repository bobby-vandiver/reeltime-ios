#import "RTBrowseAllViewDataSourceFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTUserDescription.h"
#import "RTReelDescription.h"
#import "RTVideoDescription.h"

static NSString *const BrowseCellIdentifier = @"BrowseCell";

@implementation RTBrowseAllViewDataSourceFactory

+ (RTMutableArrayDataSource *)usersDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTUserDescription *description) {
                               cell.textLabel.text = description.text;
                               cell.imageView.image = nil;
                           }];
}

+ (RTMutableArrayDataSource *)reelsDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTReelDescription *description) {
                               cell.textLabel.text = description.text;
                               cell.imageView.image = nil;
                           }];
}

+ (RTMutableArrayDataSource *)videosDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTVideoDescription *description) {
                               cell.textLabel.text = description.text;
                               cell.imageView.image = [UIImage imageWithData:description.thumbnailData];
                           }];
}

+ (RTMutableArrayDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                        configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    return [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                            cellIdentifier:cellIdentifier
                                        configureCellBlock:configureCellBlock];
}
@end
