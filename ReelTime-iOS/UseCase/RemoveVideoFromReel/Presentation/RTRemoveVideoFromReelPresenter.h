#import <Foundation/Foundation.h>

#import "RTRemoveVideoFromReelInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTRemoveVideoFromReelView;
@class RTRemoveVideoFromReelInteractor;

@interface RTRemoveVideoFromReelPresenter : NSObject <RTRemoveVideoFromReelInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTRemoveVideoFromReelView>)view
                  interactor:(RTRemoveVideoFromReelInteractor *)interactor;

- (void)requestedVideoRemovalFromReelForVideoId:(NSNumber *)videoId
                                         reelId:(NSNumber *)reelId;

@end
