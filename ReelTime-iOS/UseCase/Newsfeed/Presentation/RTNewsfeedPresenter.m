#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

static const NSUInteger INITIAL_PAGE_NUMBER = 1;

@interface RTNewsfeedPresenter ()

@property id<RTNewsfeedView> view;
@property RTNewsfeedInteractor *interactor;
@property (weak) RTNewsfeedWireframe *wireframe;

@property NSUInteger nextPage;

@end

@implementation RTNewsfeedPresenter

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTNewsfeedInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
        self.nextPage = INITIAL_PAGE_NUMBER;
    }
    return self;
}

- (void)requestedNextNewsfeedPage {
    [self.interactor newsfeedPage:self.nextPage++];
}

- (void)requestedNewsfeedReset {
    self.nextPage = INITIAL_PAGE_NUMBER;
    [self.view clearMessages];
}

- (void)retrievedNewsfeed:(RTNewsfeed *)newsfeed {
    for (RTActivity *activity in newsfeed.activities) {
        // TODO: Generate description with links for each activity
        (void)activity;
    }
}

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
