#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTActivity.h"
#import "RTActivityMessage.h"

#import "NSURL+RTURL.h"

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
    self = [super initWithInteractor:interactor];
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
