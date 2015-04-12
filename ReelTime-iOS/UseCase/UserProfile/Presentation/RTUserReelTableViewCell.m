#import "RTUserReelTableViewCell.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseVideosPresenter.h"
#import "RTVideoDescription.h"

#import "RTPagedListViewScrollHandler.h"

@interface RTUserReelTableViewCell ()

@property RTBrowseVideosPresenter *videosPresenter;
@property RTPagedListViewScrollHandler *scrollHandler;

@property UITableView *tableView;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTUserReelTableViewCell

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    [self registerTableView];
    [self registerScrollHandler];
    
    self.videosPresenter = videosPresenter;
    [self.videosPresenter requestedNextPage];
}

- (void)registerDataSource {
    
    ConfigureCellBlock configureBlock = ^(UITableViewCell *cell, RTVideoDescription *description) {
        cell.imageView.image = [UIImage imageWithData:description.thumbnailData];
        cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    };
    
    self.dataSource = [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                                       cellIdentifier:@"UserReelCell"
                                                   configureCellBlock:configureBlock];
}

- (void)registerTableView {
    self.tableView = [self createHorizontalTableView];
    [self addSubview:self.tableView];
}

- (UITableView *)createHorizontalTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;

    tableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    tableView.rowHeight = 75;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    
    tableView.dataSource = self.dataSource;
    tableView.delegate = self;
    
    return tableView;
}

- (void)registerScrollHandler {
    self.scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
}

- (void)showVideoDescription:(RTVideoDescription *)description {
    [self.dataSource addItem:description];
}

- (void)clearVideoDescriptions {
    [self.dataSource removeAllItems];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollHandler handleScrollForTableView:self.tableView withPresenter:self.videosPresenter];
}

@end
