#import "RTServerErrorMessageToErrorCodeTestHelper.h"
#import "RTServerErrors.h"

@interface RTServerErrorMessageToErrorCodeTestHelper ()

@property (copy) NSString *errorDomain;

@property (nonatomic, copy) void (^failureHandler)(RTServerErrors *serverErrors);
@property (nonatomic, copy) void (^errorCaptureBlock)(MKTArgumentCaptor *errorCaptor);

@end

@implementation RTServerErrorMessageToErrorCodeTestHelper

- (instancetype)initWithFailureHandler:(void (^)(RTServerErrors *serverErrors))failureHandler
                     errorCaptureBlock:(void (^)(MKTArgumentCaptor *errorCaptor))errorCaptureBlock {

    return [self initForErrorDomain:nil
                 withFailureHandler:failureHandler
                  errorCaptureBlock:errorCaptureBlock];
}

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *))failureHandler
                 errorCaptureBlock:(void (^)(MKTArgumentCaptor *))errorCaptureBlock {
    self = [super init];
    if (self) {
        self.errorDomain = errorDomain;
        self.failureHandler = failureHandler;
        self.errorCaptureBlock = errorCaptureBlock;
    }
    return self;
}

- (void)expectForServerMessageToErrorCodeMapping:(NSDictionary *)mapping {
    [self expectForServerMessageToErrorCodeMapping:mapping withDomain:self.errorDomain];
}

- (void)expectForServerMessageToErrorCodeMapping:(NSDictionary *)mapping
                                      withDomain:(NSString *)domain {
    for (NSString *message in mapping.allKeys) {
        NSNumber *value = mapping[message];

        NSInteger code = [value integerValue];
        [self expectServerMessage:message toMapToDomain:domain code:code];
    }
}

- (void)expectServerMessage:(NSString *)message
                toMapToCode:(NSInteger)code {
    [self expectServerMessage:message toMapToDomain:self.errorDomain code:code];
}

- (void)expectServerMessage:(NSString *)message
              toMapToDomain:(NSString *)domain
                       code:(NSInteger)code {

    RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
    serverErrors.errors = @[message];
    
    MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
    
    self.failureHandler(serverErrors);
    self.errorCaptureBlock(errorCaptor);
    
    NSArray *capturedErrors = [errorCaptor value];
    expect(capturedErrors).to.haveACountOf(1);
    
    NSError *firstError = capturedErrors[0];
    expect(firstError).to.beError(domain, code);
}

@end
