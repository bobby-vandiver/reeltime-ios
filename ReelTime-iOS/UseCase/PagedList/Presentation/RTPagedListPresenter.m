#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"
#import "RTPagedListInteractor.h"

static const NSUInteger INITIAL_PAGE_NUMBER = 1;

@interface RTPagedListPresenter ()

@property id<RTPagedListPresenterDelegate> delegate;
@property RTPagedListInteractor *interactor;

@property NSUInteger nextPage;
@property NSMutableArray *items;

@property BOOL canRequestNextPage;
@property BOOL requestInProgress;

@end

@implementation RTPagedListPresenter

- (instancetype)initWithDelegate:(id<RTPagedListPresenterDelegate>)delegate
                      interactor:(RTPagedListInteractor *)interactor {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.interactor = interactor;
        
        [self resetItems];
    }
    return self;
}

- (void)resetItems {
    self.canRequestNextPage = YES;
    self.requestInProgress = NO;

    self.nextPage = INITIAL_PAGE_NUMBER;
    self.items = [NSMutableArray array];
}

- (void)requestedNextPage {
    if (self.canRequestNextPage && !self.requestInProgress) {
        self.requestInProgress = YES;
        [self.interactor listItemsForPage:self.nextPage++];
    }
}

- (void)requestedReset {
    [self resetItems];
    [self.delegate clearPresentedItems];
}

- (void)retrievedItems:(NSArray *)items {
    for (id item in items) {
        if (![self.items containsObject:item]) {
            [self.delegate presentItem:item];
            [self.items addObject:item];
        }
    }

    self.canRequestNextPage = items.count > 0;
    self.requestInProgress = NO;
}

- (void)failedToRetrieveItemsWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
