#import "RTBrowseViewDataSourceFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTUserMessage.h"
#import "RTReelMessage.h"
#import "RTVideoMessage.h"

static NSString *const BrowseCellIdentifier = @"BrowseCell";

@implementation RTBrowseViewDataSourceFactory

+ (RTMutableArrayDataSource *)usersDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTUserMessage *message) {
                               cell.textLabel.text = message.text;
                           }];
}

+ (RTMutableArrayDataSource *)reelsDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTReelMessage *message) {
                               cell.textLabel.text = message.text;
                           }];
}

+ (RTMutableArrayDataSource *)videosDataSource {
    return [self dataSourceWithCellIdentifier:BrowseCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTVideoMessage *message) {
                               cell.textLabel.text = message.text;
                           }];
}

+ (RTMutableArrayDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                        configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    return [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                            cellIdentifier:cellIdentifier
                                        configureCellBlock:configureCellBlock];
}
@end
