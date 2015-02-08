#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTLoginViewField) {
    RTLoginViewFieldUsername,
    RTLoginViewFieldPassword
};

@protocol RTLoginView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTLoginViewField)field;

- (void)showErrorMessage:(NSString *)message;

@end
