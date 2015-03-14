#import "RTBrowseReelsPresenter.h"

#import "RTBrowseReelsView.h"
#import "RTReelWireframe.h"

#import "RTReel.h"
#import "RTReelMessage.h"

@interface RTBrowseReelsPresenter ()

@property id<RTBrowseReelsView> view;
@property id<RTReelWireframe> wireframe;

@end

@implementation RTBrowseReelsPresenter

- (instancetype)initWithView:(id<RTBrowseReelsView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTReelWireframe>)wireframe {
    self = [super initWithDelegate:self interactor:interactor];
    if (self) {
        self.view = view;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)clearPresentedItems {
    [self.view clearReelMessages];
}

- (void)presentItem:(RTReel *)reel {
    RTReelMessage *message = [RTReelMessage reelMessageWithText:reel.name
                                                      forReelId:reel.reelId];
    [self.view showReelMessage:message];
}

- (void)requestedReelDetailsForReelId:(NSNumber *)reelId {
    [self.wireframe presentReelForReelId:reelId];
}

@end
