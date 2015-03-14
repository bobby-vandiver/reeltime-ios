#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTBrowseUsersView;
@protocol RTUserWireframe;
@class RTPagedListInteractor;

@interface RTBrowseUsersPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTBrowseUsersView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTUserWireframe>)wireframe;

- (void)requestedUserDetailsForUsername:(NSString *)username;

@end
