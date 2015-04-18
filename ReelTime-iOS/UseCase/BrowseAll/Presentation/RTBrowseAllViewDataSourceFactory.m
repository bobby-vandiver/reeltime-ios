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
                               cell.textLabel.text = description.displayName;
                               cell.imageView.image = nil;
                           }];
}

+ (RTMutableArrayDataSource *)reelsDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTReelDescription *description) {
                               cell.textLabel.text = description.name;
                               cell.imageView.image = nil;
                           }];
}

+ (RTMutableArrayDataSource *)videosDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTVideoDescription *description) {
                               cell.textLabel.text = description.title;
                               cell.imageView.image = [UIImage imageWithData:description.thumbnailData];
                           }];
}

+ (RTMutableArrayDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                        configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    return [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                             cellIdentifier:cellIdentifier
                                         configureCellBlock:configureCellBlock];
}
@end
