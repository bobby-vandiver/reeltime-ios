#import <Foundation/Foundation.h>

#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTCreateReelViewField) {
    RTCreateReelViewFieldReelName,
};

@protocol RTCreateReelView <NSObject, RTErrorMessageView, RTFieldValidationErrorView>

- (void)showCreatedReelWithName:(NSString *)name;

@end
