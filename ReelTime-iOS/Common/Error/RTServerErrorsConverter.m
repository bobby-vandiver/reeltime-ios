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

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    for (NSString *message in serverErrors.errors) {
        NSNumber *code = [[self.mapping errorMessageToErrorCodeMapping] objectForKey:message];
        
        if (!code) {
            DDLogWarn(@"Received unknown server messsage: %@", message);
            code = @([self.mapping errorCodeForUnknownError]);
        }

        NSError *error = [NSError errorWithDomain:[self.mapping errorDomain]
                                             code:[code integerValue]
                                         userInfo:nil];
        [errors addObject:error];
    }

    return errors;
}

@end
