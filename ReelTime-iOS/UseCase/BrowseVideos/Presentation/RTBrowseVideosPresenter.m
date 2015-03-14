#import "RTBrowseVideosPresenter.h"

#import "RTBrowseVideosView.h"
#import "RTVideoWireframe.h"

#import "RTVideo.h"
#import "RTVideoMessage.h"

@interface RTBrowseVideosPresenter ()

@property id<RTBrowseVideosView> view;
@property id<RTVideoWireframe> wireframe;

@end

@implementation RTBrowseVideosPresenter

- (instancetype)initWithView:(id<RTBrowseVideosView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTVideoWireframe>)wireframe {
    self = [super initWithDelegate:self interactor:interactor];
    if (self) {
        self.view = view;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)clearPresentedItems {
    [self.view clearVideoMessages];
}

- (void)presentItem:(RTVideo *)video {
    RTVideoMessage *message = [RTVideoMessage videoMessageWithText:video.title
                                                           videoId:video.videoId];
    [self.view showVideoMessage:message];
}

- (void)requestedVideoDetailsForVideoId:(NSNumber *)videoId {
    [self.wireframe presentVideoForVideoId:videoId];
}

@end
