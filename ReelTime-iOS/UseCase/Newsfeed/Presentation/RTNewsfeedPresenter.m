#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

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
        RTStringWithEmbeddedLinks *message = [self createMessageForActivity:activity];
        [self.view showMessage:message forActivityType:RTActivityTypeCreateReel];
    }
}

- (RTStringWithEmbeddedLinks *)createMessageForActivity:(RTActivity *)activity {
    NSDictionary *messageFormatsForActivites = @{
        @(RTActivityTypeCreateReel): @"%@ created the %@ reel"
    };
    
    NSString *username = activity.user.username;
    NSString *reelName = activity.reel.name;

    NSString *format = messageFormatsForActivites[activity.type];
    NSString *text = [NSString stringWithFormat:format, username, reelName];
    
    RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] initWithString:text];
    
    NSString *userUrl = [NSString stringWithFormat:@"reeltime://users/%@", username];

    [message addLinkToURL:[NSURL URLWithString:userUrl] forString:username];

    NSNumber *reelId = activity.reel.reelId;
    NSString *reelUrl = [NSString stringWithFormat:@"reeltime://reels/%@", reelId];
    
    [message addLinkToURL:[NSURL URLWithString:reelUrl] forString:reelName];
    
    return message;
}

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
