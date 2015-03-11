#import "RTPagedListPresenter.h"
#import "RTPagedListInteractor.h"

static const NSUInteger INITIAL_PAGE_NUMBER = 1;

@interface RTPagedListPresenter ()

@property RTPagedListInteractor *interactor;

@property NSUInteger nextPage;
@property NSMutableArray *items;

@end

@implementation RTPagedListPresenter

- (instancetype)initWithInteractor:(RTPagedListInteractor *)interactor {
    self = [super init];
    if (self) {
        self.interactor = interactor;
        [self resetItems];
    }
    return self;
}

- (void)resetItems {
    self.nextPage = INITIAL_PAGE_NUMBER;
    self.items = [NSMutableArray array];
}

- (void)requestedNextPage {
    [self.interactor listItemsForPage:self.nextPage++];
}

- (void)requestedReset {
    [self resetItems];
    [self clearPresentedItems];
}

- (void)clearPresentedItems {
    // TODO: Throw exception
}

- (void)retrievedItems:(NSArray *)items {
    for (id item in items) {
        if (![self.items containsObject:item]) {
            [self presentItem:item];
            [self.items addObject:item];
        }
    }
}

- (void)presentItem:(id)item {
    // TODO: Throw exception
}

- (void)failedToRetrieveItemsWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
