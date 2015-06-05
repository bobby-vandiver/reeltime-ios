#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"

@protocol RTBrowseClientsView;
@class RTPagedListInteractor;

@interface RTBrowseClientsPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate>

- (instancetype)initWithView:(id<RTBrowseClientsView>)view
                  interactor:(RTPagedListInteractor *)interactor;

@end
