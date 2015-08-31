#import "RTServerErrorMessageToErrorCodeTestHelper.h"
#import "RTServerErrors.h"

@interface RTServerErrorMessageToErrorCodeTestHelper ()

@property (copy) NSString *errorDomain;

@property (nonatomic, copy) void (^failureHandler)(RTServerErrors *serverErrors);
@property (nonatomic, copy) void (^errorCaptureBlock)(MKTArgumentCaptor *errorCaptor);
@property (nonatomic, copy) id (^errorRetrievalBlock)();

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
               errorRetrievalBlock:(id (^)())errorRetrievalBlock {

    return [self initForErrorDomain:errorDomain
                 withFailureHandler:failureHandler
                  errorCaptureBlock:nil
                errorRetrievalBlock:errorRetrievalBlock];
}

- (instancetype)initForErrorDomain:(NSString *)errorDomain
                withFailureHandler:(void (^)(RTServerErrors *))failureHandler
                 errorCaptureBlock:(void (^)(MKTArgumentCaptor *))errorCaptureBlock
               errorRetrievalBlock:(id (^)())errorRetrievalBlock {
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

    id capturedErrors;
    
    if (self.errorCaptureBlock) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        
        self.errorCaptureBlock(errorCaptor);
        capturedErrors = [errorCaptor value];
    }
    else {
        capturedErrors = self.errorRetrievalBlock();
    }

    [self checkCapturedErrors:capturedErrors forDomain:domain code:code];
}

- (void)checkCapturedErrors:(id)capturedErrors
                  forDomain:(NSString *)domain
                       code:(NSInteger)code {
    NSError *error;
    
    if ([capturedErrors isKindOfClass:[NSArray class]]) {
        expect(capturedErrors).to.haveACountOf(1);
        error = capturedErrors[0];
    }
    else if ([capturedErrors isKindOfClass:[NSError class]]){
        error = capturedErrors;
    }
    else {
        NSString *message = [NSString stringWithFormat:@"Expected an NSError or NSArray but got = %@", [capturedErrors class]];
        failure(message);
    }
    
    expect(error).to.beError(domain, code);
}

@end
