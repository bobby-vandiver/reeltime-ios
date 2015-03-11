#import "RTPagedListInteractor.h"

#import "RTPagedListInteractorDelegate.h"
#import "RTPagedListDataManager.h"

#import "RTErrorFactory.h"

@interface RTPagedListInteractor ()

@property (weak) id<RTPagedListInteractorDelegate> delegate;
@property RTPagedListDataManager *dataManager;

@end

@implementation RTPagedListInteractor

- (instancetype)initWithDelegate:(id<RTPagedListInteractorDelegate>)delegate
                     dataManager:(RTPagedListDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)listItemsForPage:(NSUInteger)page {
    if (page > 0) {
        [self.dataManager retrievePage:page callback:^(NSArray *items) {
            [self.delegate retrievedItems:items];
        }];
    }
    else {
        NSError *error = [RTErrorFactory pagedListErrorWithCode:RTPagedListErrorInvalidPageNumber];
        [self.delegate failedToRetrieveItemsWithError:error];
    }
}

@end
