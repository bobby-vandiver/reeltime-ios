#import "RTUserReelTableViewCell.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseVideosPresenter.h"
#import "RTVideoDescription.h"

#import "RTVideoThumbnailTableViewCell.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTLogging.h"

@interface RTUserReelTableViewCell ()

@property RTBrowseVideosPresenter *videosPresenter;
@property RTPagedListViewScrollHandler *scrollHandler;

@property UITableView *tableView;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTUserReelTableViewCell

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    [self registerDataSource];
    [self registerTableView];
    [self registerScrollHandler];
    
    self.videosPresenter = videosPresenter;
    [self.videosPresenter requestedNextPage];
}

- (void)registerDataSource {
    
    ConfigureCellBlock configureBlock = ^(RTVideoThumbnailTableViewCell *cell, RTVideoDescription *description) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.thumbnail.image = [UIImage imageWithData:description.thumbnailData];
        });
    };
    
    self.dataSource = [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                                       cellIdentifier:@"UserReelVideoCell"
                                                   configureCellBlock:configureBlock];
}

- (void)registerTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 75, 375)
                                                          style:UITableViewStylePlain];
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    tableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    tableView.frame = CGRectMake(0, 0, 375, 75);
    
    tableView.rowHeight = 75;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    
    tableView.dataSource = self.dataSource;
    tableView.delegate = self;
    
    [tableView registerClass:[RTVideoThumbnailTableViewCell class] forCellReuseIdentifier:@"UserReelVideoCell"];

    self.tableView = tableView;
    [self addSubview:tableView];
}

- (void)registerScrollHandler {
    self.scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
}

- (void)showVideoDescription:(RTVideoDescription *)description {
    [self.dataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearVideoDescriptions {
    [self.dataSource removeAllItems];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.scrollHandler handleScrollForTableView:self.tableView withPresenter:self.videosPresenter];
}

@end
