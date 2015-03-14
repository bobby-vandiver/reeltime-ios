#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTBrowseReelsView;
@protocol RTReelWireframe;
@class RTPagedListInteractor;

@interface RTBrowseReelsPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTBrowseReelsView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTReelWireframe>)wireframe;

- (void)requestedReelDetailsForReelId:(NSNumber *)reelId;

@end
