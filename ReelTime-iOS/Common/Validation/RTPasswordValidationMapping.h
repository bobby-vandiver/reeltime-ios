#import <Foundation/Foundation.h>

@interface RTPasswordValidationMapping : NSObject

@property (readonly) NSString *errorDomain;

@property (readonly) NSInteger missingPasswordErrorCode;
@property (readonly) NSInteger invalidPasswordErrorCode;

@property (readonly) NSInteger missingConfirmationPasswordErrorCode;
@property (readonly) NSInteger confirmationPasswordMismatchErrorCode;

+ (instancetype)mappingWithErrorDomain:(NSString *)errorDomain
              missingPasswordErrorCode:(NSInteger)missingPasswordErrorCode
              invalidPasswordErrorCode:(NSInteger)invalidPasswordErrorCode
  missingConfirmationPasswordErrorCode:(NSInteger)missingConfirmationPasswordErrorCode
 confirmationPasswordMismatchErrorCode:(NSInteger)confirmationPasswordMismatchErrorCode;

@end
