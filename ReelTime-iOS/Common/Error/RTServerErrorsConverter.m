#import "RTServerErrorsConverter.h"
#import "RTServerErrors.h"
#import "RTLogging.h"

@implementation RTServerErrorsConverter

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors
                     withMapping:(NSDictionary *)mapping
                       converter:(NSError *(^)(NSInteger))converter {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
   
    for (NSString *message in serverErrors.errors) {
        NSNumber *code = [mapping objectForKey:message];
        
        if (code) {
            NSError *error = converter([code integerValue]);
            [errors addObject:error];
        }
        else {
            DDLogWarn(@"Received unknown server messsage: %@", message);
        }
    }
    
    return errors;
}

@end
