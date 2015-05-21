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
               errorRetrievalBlock:(NSArray *(^)())errorRetrievalBlock;

- (void)expectForServerMessageToErrorCodeMapping:(NSDictionary *)mapping;

- (void)expectServerMessage:(NSString *)message
                toMapToCode:(NSInteger)code;

- (void)expectServerMessage:(NSString *)message
              toMapToDomain:(NSString *)domain
                       code:(NSInteger)code;

@end
