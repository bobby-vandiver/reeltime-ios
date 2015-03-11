#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTPagedListInteractor.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTActivityMessage.h"
#import "NSURL+RTURL.h"

static const NSUInteger INITIAL_PAGE_NUMBER = 1;

@interface RTNewsfeedPresenter ()

@property id<RTNewsfeedView> view;
@property RTPagedListInteractor *interactor;
@property (weak) RTNewsfeedWireframe *wireframe;
@property RTNewsfeedMessageSource *messageSource;

@property NSUInteger nextPage;
@property NSMutableArray *activities;

@end

@implementation RTNewsfeedPresenter

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
        self.messageSource = messageSource;

        [self resetActivites];
    }
    return self;
}

- (void)resetActivites {
    self.nextPage = INITIAL_PAGE_NUMBER;
    self.activities = [NSMutableArray array];
}

- (void)requestedNextNewsfeedPage {
    [self.interactor listItemsForPage:self.nextPage++];
}

- (void)requestedNewsfeedReset {
    [self resetActivites];
    [self.view clearMessages];
}

- (void)retrievedItems:(NSArray *)items {
    for (RTActivity *activity in items) {
        if (![self.activities containsObject:activity]) {
            [self showActivity:activity];
            [self.activities addObject:activity];
        }
    }
}

- (void)showActivity:(RTActivity *)activity {
    RTActivityMessage *message = [self.messageSource messageForActivity:activity];
    [self.view showMessage:message];
}

- (void)failedToRetrieveItemsWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (url.isUserURL) {
        [self.wireframe presentUserForUsername:url.username];
    }
    else if (url.isReelURL) {
        [self.wireframe presentReelForReelId:url.reelId];
    }
    else if (url.isVideoURL) {
        [self.wireframe presentVideoForVideoId:url.videoId];
    }
    else {
        // TODO: Log unknown URL
    }
}

@end
