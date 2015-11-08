#import <Foundation/Foundation.h>

#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTUploadVideoViewField) {
    RTUploadVideoViewFieldVideoTitle,
    RTUploadVideoViewFieldReelName
};

@protocol RTUploadVideoView <NSObject, RTErrorMessageView, RTFieldValidationErrorView>

@end
