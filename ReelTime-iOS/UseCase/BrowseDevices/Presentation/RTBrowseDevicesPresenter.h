#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTBrowseDevicesView;
@class RTPagedListInteractor;

@interface RTBrowseDevicesPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTBrowseDevicesView>)view
                  interactor:(RTPagedListInteractor *)interactor;

@end
