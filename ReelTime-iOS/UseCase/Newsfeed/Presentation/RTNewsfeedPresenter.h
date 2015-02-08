#import <Foundation/Foundation.h>
#import "RTNewsfeedInteractorDelegate.h"

@protocol RTNewsfeedView;
@class RTNewsfeedInteractor;
@class RTNewsfeedWireframe;

@interface RTNewsfeedPresenter : NSObject <RTNewsfeedInteractorDelegate>

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTNewsfeedInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe;

- (void)requestedNewsfeedPage:(NSUInteger)page;

@end
