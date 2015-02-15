#import <Foundation/Foundation.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "RTNewsfeedInteractorDelegate.h"

@protocol RTNewsfeedView;
@class RTNewsfeedInteractor;
@class RTNewsfeedWireframe;
@class RTNewsfeedMessageSource;

@interface RTNewsfeedPresenter : NSObject <RTNewsfeedInteractorDelegate, TTTAttributedLabelDelegate>

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTNewsfeedInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource;

- (void)requestedNextNewsfeedPage;

- (void)requestedNewsfeedReset;

@end
