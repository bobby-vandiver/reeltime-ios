#import <Foundation/Foundation.h>

#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTLoginViewField) {
    RTLoginViewFieldUsername,
    RTLoginViewFieldPassword
};

@protocol RTLoginView <NSObject, RTErrorMessageView, RTFieldValidationErrorView>

@end
