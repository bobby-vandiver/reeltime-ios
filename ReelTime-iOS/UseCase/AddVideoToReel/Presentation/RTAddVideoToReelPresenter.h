#import <Foundation/Foundation.h>

#import "RTAddVideoToReelInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTAddVideoToReelView;
@class RTAddVideoToReelInteractor;

@interface RTAddVideoToReelPresenter : NSObject <RTAddVideoToReelInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTAddVideoToReelView>)view
                  interactor:(RTAddVideoToReelInteractor *)interactor;

- (void)requestedVideoAdditionForVideoId:(NSNumber *)videoId
                         toReelForReelId:(NSNumber *)reelId;

@end
