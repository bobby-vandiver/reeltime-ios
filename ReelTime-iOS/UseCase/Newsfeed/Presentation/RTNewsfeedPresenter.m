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
        RTActivityType type = [activity.type integerValue];
        [self.view showMessage:message forActivityType:type];
    }
}

+ (NSString *)messageFormatForActivityType:(NSNumber *)type {
    NSDictionary *messageFormatsForActivites = @{
        @(RTActivityTypeCreateReel): @"%@ created the %@ reel",
        @(RTActivityTypeJoinReelAudience): @"%@ joined the audience of the %@ reel",
        @(RTActivityTypeAddVideoToReel): @"%@ added the video %@ to the %@ reel"
    };

    return messageFormatsForActivites[type];
}

- (RTStringWithEmbeddedLinks *)createMessageForActivity:(RTActivity *)activity {
    RTUser *user = activity.user;
    RTReel *reel = activity.reel;
    RTVideo *video = activity.video;

    NSString *text = [self textForActivity:activity];
    RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] initWithString:text];
    
    NSURL *userURL = [self URLforUser:user];
    [message addLinkToURL:userURL forString:user.username];
   
    NSURL *reelURL = [self URLforReel:reel];
    [message addLinkToURL:reelURL forString:reel.name];

    if ([activity.type isEqual:@(RTActivityTypeAddVideoToReel)]) {
        NSURL *videoURL = [self URLforVideo:video];
        [message addLinkToURL:videoURL forString:video.title];
    }
    
    return message;
}

- (NSString *)textForActivity:(RTActivity *)activity {
    NSString *username = activity.user.username;
    NSString *reelName = activity.reel.name;
    NSString *videoTitle = activity.video.title;
    
    NSString *format = [RTNewsfeedPresenter messageFormatForActivityType:activity.type];
    NSString *text;
    
    if ([activity.type isEqual:@(RTActivityTypeAddVideoToReel)]) {
        text = [NSString stringWithFormat:format, username, videoTitle, reelName];
    }
    else {
        text = [NSString stringWithFormat:format, username, reelName];
    }

    return text;
}

- (NSURL *)URLforUser:(RTUser *)user {
    NSString *url = [NSString stringWithFormat:@"reeltime://users/%@", user.username];
    return [NSURL URLWithString:url];
}

- (NSURL *)URLforReel:(RTReel *)reel {
    NSString *url = [NSString stringWithFormat:@"reeltime://reels/%@", reel.reelId];
    return [NSURL URLWithString:url];
}

- (NSURL *)URLforVideo:(RTVideo *)video {
    NSString *url = [NSString stringWithFormat:@"reeltime://videos/%@", video.videoId];
    return [NSURL URLWithString:url];
}

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
