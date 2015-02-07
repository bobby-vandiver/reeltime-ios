#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedInteractorDelegate.h"
#import "RTNewsfeedDataManager.h"

#import "RTErrorFactory.h"

@interface RTNewsfeedInteractor ()

@property (weak) id<RTNewsfeedInteractorDelegate> delegate;
@property RTNewsfeedDataManager *dataManager;

@end

@implementation RTNewsfeedInteractor

- (instancetype)initWithDelegate:(id<RTNewsfeedInteractorDelegate>)delegate
                     dataManager:(RTNewsfeedDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)newsfeedPage:(NSUInteger)page {
    if (page > 0) {
        [self.dataManager retrieveNewsfeedPage:page callback:^(RTNewsfeed *newsfeed) {
            [self.delegate retrievedNewsfeed:newsfeed];
        }];
    }
    else {
        NSError *error = [RTErrorFactory newsfeedErrorWithCode:RTNewsfeedErrorInvalidPageNumber];
        [self.delegate failedToRetrieveNewsfeedWithError:error];
    }
}

@end
