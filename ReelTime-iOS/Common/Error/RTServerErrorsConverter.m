#import "RTServerErrorsConverter.h"
#import "RTServerErrorMessageToErrorCodeMapping.h"
#import "RTServerErrors.h"
#import "RTLogging.h"

@interface RTServerErrorsConverter ()

@property id<RTServerErrorMessageToErrorCodeMapping> mapping;

@end

@implementation RTServerErrorsConverter

- (instancetype)initWithMapping:(id<RTServerErrorMessageToErrorCodeMapping>)mapping {
    self = [super init];
    if (self) {
        self.mapping = mapping;
    }
    return self;
}

- (NSError *)convertFirstErrorFromServerErrors:(RTServerErrors *)serverErrors {
    NSString *message = serverErrors.errors.count > 0 ? serverErrors.errors[0] : nil;
    return [self convertErrorMessage:message];
}

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    for (NSString *message in serverErrors.errors) {
        NSError *error = [self convertErrorMessage:message];
        [errors addObject:error];
    }

    return errors;
}

- (NSError *)convertErrorMessage:(NSString *)message {
    NSNumber *code = [[self.mapping errorMessageToErrorCodeMapping] objectForKey:message];
    
    if (!code) {
        DDLogWarn(@"Received unknown server messsage: %@", message);
        code = @([self.mapping errorCodeForUnknownError]);
    }
    
    return [NSError errorWithDomain:[self.mapping errorDomain]
                               code:[code integerValue]
                           userInfo:nil];
}

@end
