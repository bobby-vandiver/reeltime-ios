#import <Foundation/Foundation.h>
#import "RTAddVideoToReelInteractorDelegate.h"

@protocol RTAddVideoToReelView;
@class RTAddVideoToReelInteractor;

@interface RTAddVideoToReelPresenter : NSObject <RTAddVideoToReelInteractorDelegate>

- (instancetype)initWithView:(id<RTAddVideoToReelView>)view
                  interactor:(RTAddVideoToReelInteractor *)interactor;

- (void)requestedVideoAdditionForVideoId:(NSNumber *)videoId
                         toReelForReelId:(NSNumber *)reelId;

@end
