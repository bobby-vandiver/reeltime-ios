#import <Foundation/Foundation.h>
#import "RTTestCommon.h"

@class RTServerErrors;

@interface RTServerErrorMessageToErrorCodeTestHelper : NSObject

- (instancetype)initWithFailureHandler:(void (^)(RTServerErrors *serverErrors))failureHandler
                     errorCaptureBlock:(void (^)(MKTArgumentCaptor *errorCaptor))errorCaptureBlock;

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *serverErrors))failureHandler
                 errorCaptureBlock:(void (^)(MKTArgumentCaptor *errorCaptor))errorCaptureBlock;

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *))failureHandler
               errorRetrievalBlock:(id (^)())errorRetrievalBlock;

- (void)expectForServerMessageToErrorCodeMapping:(NSDictionary *)mapping;

@end
