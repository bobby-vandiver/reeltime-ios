#import "RTUserReelTableViewCell.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseVideosPresenter.h"

#import "RTVideoDescription.h"
#import "RTVideoThumbnailCell.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTLogging.h"

@interface RTUserReelTableViewCell ()

@property RTBrowseVideosPresenter *videosPresenter;
@property RTPagedListViewScrollHandler *scrollHandler;

@property UICollectionView *collectionView;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTUserReelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCollectionView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCollectionView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(75, 75);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[RTVideoThumbnailCell class] forCellWithReuseIdentifier:@"UserReelVideoCell"];
    [self.contentView addSubview:self.collectionView];
    
    [self registerDataSource];
    
    [self.collectionView setDataSource:self.dataSource];
    [self.collectionView setDelegate:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    self.videosPresenter = videosPresenter;
    [self.videosPresenter requestedNextPage];
}

- (void)registerDataSource {
    
    ConfigureCellBlock configureBlock = ^(RTVideoThumbnailCell *cell, RTVideoDescription *description) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            if (!cell.thumbnailView) {
                UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
                
                thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
                thumbnailView.opaque = YES;
                
                cell.thumbnailView = thumbnailView;
                [cell.contentView addSubview:thumbnailView];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.thumbnailView.image = [UIImage imageWithData:description.thumbnailData];
            });
        });
    };
    
    self.dataSource = [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                                       cellIdentifier:@"UserReelVideoCell"
                                                   configureCellBlock:configureBlock];
}

- (void)registerScrollHandler {
    self.scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
}

- (void)showVideoDescription:(RTVideoDescription *)description {
    [self.dataSource addItem:description];
    [self.collectionView reloadData];
}

- (void)clearVideoDescriptions {
    [self.dataSource removeAllItems];
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.scrollHandler handleScrollForTableView:self.tableView withPresenter:self.videosPresenter];
}

@end
