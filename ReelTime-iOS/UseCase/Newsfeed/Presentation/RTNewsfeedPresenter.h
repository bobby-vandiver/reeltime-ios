#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@protocol RTNewsfeedView;
@class RTPagedListInteractor;
@class RTNewsfeedWireframe;
@class RTNewsfeedMessageSource;

@interface RTNewsfeedPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate, TTTAttributedLabelDelegate>

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource;

@end
