#import <Foundation/Foundation.h>

#import "RTDeleteReelInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTDeleteReelView;
@class RTDeleteReelInteractor;

@interface RTDeleteReelPresenter : NSObject <RTDeleteReelInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTDeleteReelView>)view
                  interactor:(RTDeleteReelInteractor *)interactor;

- (void)requestedReelDeletionForReelId:(NSNumber *)reelId;

@end
