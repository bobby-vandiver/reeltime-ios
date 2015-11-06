#import <Foundation/Foundation.h>

@protocol RTUploadVideoInteractorDelegate;

@class RTUploadVideoDataManager;
@class RTUploadVideoValidator;

@interface RTUploadVideoInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTUploadVideoInteractorDelegate>)delegate
                     dataManager:(RTUploadVideoDataManager *)dataManager
                       validator:(RTUploadVideoValidator *)validator;

- (void)uploadVideo:(NSURL *)videoUrl
          thumbnail:(NSURL *)thumbnailUrl
     withVideoTitle:(NSString *)videoTitle
     toReelWithName:(NSString *)reelName;

@end
