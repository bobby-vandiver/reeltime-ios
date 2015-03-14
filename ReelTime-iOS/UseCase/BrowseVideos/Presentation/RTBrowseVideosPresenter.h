#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTBrowseVideosView;
@protocol RTVideoWireframe;
@class RTPagedListInteractor;

@interface RTBrowseVideosPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTBrowseVideosView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTVideoWireframe>)wireframe;

- (void)requestedVideoDetailsForVideoId:(NSNumber *)videoId;

@end
