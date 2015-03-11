#import <Foundation/Foundation.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "RTPagedListInteractorDelegate.h"

@protocol RTNewsfeedView;
@class RTPagedListInteractor;
@class RTNewsfeedWireframe;
@class RTNewsfeedMessageSource;

@interface RTNewsfeedPresenter : NSObject <RTPagedListInteractorDelegate, TTTAttributedLabelDelegate>

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource;

- (void)requestedNextNewsfeedPage;

- (void)requestedNewsfeedReset;

@end
