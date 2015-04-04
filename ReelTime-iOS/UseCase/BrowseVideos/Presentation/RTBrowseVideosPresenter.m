#import "RTBrowseVideosPresenter.h"

#import "RTBrowseVideosView.h"
#import "RTVideoWireframe.h"

#import "RTVideo.h"
#import "RTThumbnail.h"

#import "RTVideoDescription.h"

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
    [self.view clearVideoDescriptions];
}

- (void)presentItem:(RTVideo *)video {
    RTVideoDescription *description = [RTVideoDescription videoDescriptionWithText:video.title
                                                                           videoId:video.videoId
                                                                     thumbnailData:video.thumbnail.data];
    [self.view showVideoDescription:description];
}

- (void)requestedVideoDetailsForVideoId:(NSNumber *)videoId {
    [self.wireframe presentVideoForVideoId:videoId];
}

@end
