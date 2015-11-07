#import <Foundation/Foundation.h>

#import "RTUploadVideoInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTUploadVideoView;
@class RTUploadVideoInteractor;
@class RTUploadVideoWireframe;

@interface RTUploadVideoPresenter : NSObject <RTUploadVideoInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTUploadVideoView>)view
                  interactor:(RTUploadVideoInteractor *)interactor
                   wireframe:(RTUploadVideoWireframe *)wireframe;

- (void)requestedUploadForVideo:(NSURL *)videoUrl
                  withThumbnail:(NSURL *)thumbnailUrl
                     videoTitle:(NSString *)videoTitle
                 toReelWithName:(NSString *)reelName;

@end
