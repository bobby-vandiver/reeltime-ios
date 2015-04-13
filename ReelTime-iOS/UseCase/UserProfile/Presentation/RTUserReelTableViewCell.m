#import "RTUserReelTableViewCell.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseVideosPresenter.h"
#import "RTVideoDescription.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTLogging.h"

@interface RTUserReelTableViewCell ()

@property RTBrowseVideosPresenter *videosPresenter;
@property RTPagedListViewScrollHandler *scrollHandler;

@property UITableView *tableView;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTUserReelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 416);
    }
    return self;
}

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    [self registerDataSource];
    [self registerTableView];
    [self registerScrollHandler];
    
    self.videosPresenter = videosPresenter;
    [self.videosPresenter requestedNextPage];
}

- (void)registerDataSource {
    
    ConfigureCellBlock configureBlock = ^(UITableViewCell *cell, RTVideoDescription *description) {
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 75, 75);
        cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            UIImage *thumbnail = [UIImage imageWithData:description.thumbnailData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = thumbnail;
            });
        });        
    };
    
    self.dataSource = [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                                       cellIdentifier:@"UserReelVideoCell"
                                                   configureCellBlock:configureBlock];
}

- (void)registerTableView {
    self.tableView = [self createHorizontalTableView];
    [self addSubview:self.tableView];
}

- (UITableView *)createHorizontalTableView {
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
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserReelVideoCell"];
    
    return tableView;
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
    [self.scrollHandler handleScrollForTableView:self.tableView withPresenter:self.videosPresenter];
}

@end
