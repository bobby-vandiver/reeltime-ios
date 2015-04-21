#import <Foundation/Foundation.h>

@class RTBrowseVideosPresenter;
@protocol RTBrowseVideosView;
@protocol RTVideoWireframe;

@protocol RTBrowseReelVideosPresenterFactory <NSObject>

- (RTBrowseVideosPresenter *)browseReelVideosPresenterForReelId:(NSNumber *)reelId
                                                       username:(NSString *)username
                                                           view:(id<RTBrowseVideosView>)view
                                                      wireframe:(id<RTVideoWireframe>)wireframe;

@end
