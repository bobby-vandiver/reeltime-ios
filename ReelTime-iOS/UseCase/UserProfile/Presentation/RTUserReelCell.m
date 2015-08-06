#import "RTUserReelCell.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseVideosPresenter.h"

#import "RTVideoDescription.h"
#import "RTVideoThumbnailCell.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTLogging.h"

static NSString *const UserReelVideoCellIdentifier = @"UserReelVideoCell";

@interface RTUserReelCell ()

@property RTBrowseVideosPresenter *videosPresenter;
@property RTPagedListViewScrollHandler *scrollHandler;

@property UICollectionView *collectionView;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTUserReelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCollectionView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createCollectionView];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // TODO: Reconcile this with thumbnail support object!
    layout.itemSize = CGSizeMake(70, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[RTVideoThumbnailCell class] forCellWithReuseIdentifier:UserReelVideoCellIdentifier];
    [self.contentView addSubview:self.collectionView];
    
    [self createDataSource];
    [self.collectionView setDataSource:self.dataSource];

    [self createScrollHandler];
    [self.collectionView setDelegate:self];
}

- (void)createDataSource {
    
    ConfigureCellBlock configureBlock = ^(RTVideoThumbnailCell *cell, RTVideoDescription *description) {
        if (!cell.thumbnailView) {
            UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
            
            thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
            thumbnailView.opaque = YES;
            
            cell.thumbnailView = thumbnailView;
            [cell.contentView addSubview:thumbnailView];
        }

        cell.thumbnailView.image = [UIImage imageWithData:description.thumbnailData];
    };

    self.dataSource = [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                                        cellIdentifier:UserReelVideoCellIdentifier
                                                    configureCellBlock:configureBlock];
}

- (void)createScrollHandler {
    self.scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    self.videosPresenter = videosPresenter;
    [self.videosPresenter requestedNextPage];
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
    [self.scrollHandler handleScrollForCollectionView:self.collectionView withPresenter:self.videosPresenter];
}

@end
