#import "RTBrowseViewDataSourceFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTUserMessage.h"
#import "RTReelMessage.h"
#import "RTVideoMessage.h"

static NSString *const UserCellIdentifier = @"BrowseUsersCell";
static NSString *const ReelCellIdentifier = @"BrowseReelsCell";
static NSString *const VideoCellIdentifier = @"BrowseVideosCell";

@implementation RTBrowseViewDataSourceFactory

+ (RTMutableArrayDataSource *)usersDataSource {
    return [self dataSourceWithCellIdentifier:UserCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTUserMessage *message) {
                           }];
}

+ (RTMutableArrayDataSource *)reelsDataSource {
    return [self dataSourceWithCellIdentifier:ReelCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTReelMessage *message) {
                           }];
}

+ (RTMutableArrayDataSource *)videosDataSource {
    return [self dataSourceWithCellIdentifier:VideoCellIdentifier
                           configureCellBlock:^(UITableViewCell *cell, RTVideoMessage *message) {
                           }];
}

+ (RTMutableArrayDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                        configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    return [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                            cellIdentifier:cellIdentifier
                                        configureCellBlock:configureCellBlock];
}
@end
