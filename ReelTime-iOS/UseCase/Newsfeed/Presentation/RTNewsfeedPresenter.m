#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTActivity.h"
#import "RTActivityMessage.h"

@interface RTNewsfeedPresenter ()

@property id<RTNewsfeedView> view;
@property (weak) RTNewsfeedWireframe *wireframe;
@property RTNewsfeedMessageSource *messageSource;

@end

@implementation RTNewsfeedPresenter

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource {
    self = [super initWithDelegate:self interactor:interactor];
    if (self) {
        self.view = view;
        self.wireframe = wireframe;
        self.messageSource = messageSource;
    }
    return self;
}

- (void)clearPresentedItems {
    [self.view clearMessages];
}

- (void)presentItem:(RTActivity *)activity {
    RTActivityMessage *message = [self.messageSource messageForActivity:activity];
    [self.view showMessage:message];
}

- (void)requestedUserDetailsForUsername:(NSString *)username {
    [self.wireframe presentUserForUsername:username];
}

- (void)requestedReelDetailsForReelId:(NSNumber *)reelId
                        ownerUsername:(NSString *)ownerUsername {
    [self.wireframe presentReelForReelId:reelId ownerUsername:ownerUsername];
}

- (void)requestedVideoDetailsForVideoId:(NSNumber *)videoId {
    [self.wireframe presentVideoForVideoId:videoId];
}

@end
