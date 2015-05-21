#import "RTServerErrorMessageToErrorCodeTestHelper.h"
#import "RTServerErrors.h"

@interface RTServerErrorMessageToErrorCodeTestHelper ()

@property (copy) NSString *errorDomain;

@property (nonatomic, copy) void (^failureHandler)(RTServerErrors *serverErrors);
@property (nonatomic, copy) void (^errorCaptureBlock)(MKTArgumentCaptor *errorCaptor);
@property (nonatomic, copy) NSArray *(^errorRetrievalBlock)();

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

    return [self initForErrorDomain:errorDomain
                 withFailureHandler:failureHandler
                  errorCaptureBlock:errorCaptureBlock
                errorRetrievalBlock:nil];
}

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *))failureHandler
               errorRetrievalBlock:(NSArray *(^)())errorRetrievalBlock {

    return [self initForErrorDomain:errorDomain
                 withFailureHandler:failureHandler
                  errorCaptureBlock:nil
                errorRetrievalBlock:errorRetrievalBlock];
}

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *))failureHandler
                 errorCaptureBlock:(void (^)(MKTArgumentCaptor *))errorCaptureBlock
               errorRetrievalBlock:(NSArray *(^)())errorRetrievalBlock {
    self = [super init];
    if (self) {
        self.errorDomain = errorDomain;
        self.failureHandler = failureHandler;
        self.errorCaptureBlock = errorCaptureBlock;
        self.errorRetrievalBlock = errorRetrievalBlock;
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
    
    self.failureHandler(serverErrors);

    NSArray *capturedErrors;
    
    if (self.errorCaptureBlock) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        self.errorCaptureBlock(errorCaptor);
        
        capturedErrors = [errorCaptor value];
    }
    else {
        capturedErrors = self.errorRetrievalBlock();
    }
    
    expect(capturedErrors).to.haveACountOf(1);
    
    NSError *firstError = capturedErrors[0];
    expect(firstError).to.beError(domain, code);
}

@end
