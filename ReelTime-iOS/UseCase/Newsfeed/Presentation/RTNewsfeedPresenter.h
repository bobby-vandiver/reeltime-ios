#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTNewsfeedView;
@class RTPagedListInteractor;
@class RTNewsfeedWireframe;
@class RTNewsfeedMessageSource;

@interface RTNewsfeedPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource;

- (void)requestedUserDetailsForUsername:(NSString *)username;

- (void)requestedReelDetailsForReelId:(NSNumber *)reelId
                        ownerUsername:(NSString *)ownerUsername;

- (void)requestedVideoDetailsForVideoId:(NSNumber *)videoId;

@end
