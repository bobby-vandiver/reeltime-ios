#import <Foundation/Foundation.h>

#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTDeviceRegistrationViewField) {
    RTDeviceRegistrationViewFieldUsername,
    RTDeviceRegistrationViewFieldPassword,
    RTDeviceRegistrationViewFieldClientName
};

@protocol RTDeviceRegistrationView <NSObject, RTErrorMessageView, RTFieldValidationErrorView>

@end
