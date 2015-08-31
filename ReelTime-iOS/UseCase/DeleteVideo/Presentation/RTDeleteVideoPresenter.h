#import <Foundation/Foundation.h>

#import "RTDeleteVideoInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTDeleteVideoView;
@class RTDeleteVideoInteractor;

@interface RTDeleteVideoPresenter : NSObject <RTDeleteVideoInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTDeleteVideoView>)view
                  interactor:(RTDeleteVideoInteractor *)interactor;

- (void)requestedVideoDeletionForVideoId:(NSNumber *)videoId;

@end
