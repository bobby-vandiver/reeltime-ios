#import <Foundation/Foundation.h>
#import "RTDeleteVideoInteractorDelegate.h"

@protocol RTDeleteVideoView;
@class RTDeleteVideoInteractor;

@interface RTDeleteVideoPresenter : NSObject <RTDeleteVideoInteractorDelegate>

- (instancetype)initWithView:(id<RTDeleteVideoView>)view
                  interactor:(RTDeleteVideoInteractor *)interactor;

- (void)requestedVideoDeletionForVideoId:(NSNumber *)videoId;

@end
