#import "RTFilePathGenerator.h"
#import "RTLogging.h"

@interface RTFilePathGenerator ()

@property NSFileManager *fileManager;

@end

@implementation RTFilePathGenerator

- (instancetype)initWithFileManager:(NSFileManager *)fileManager {
    self = [super init];
    if (self) {
        self.fileManager = fileManager;
    }
    return self;
}

- (NSString *)tempFilePath:(NSString *)fileExtension {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *filename = [uuid stringByAppendingString:fileExtension];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:filename];
    
    if ([self.fileManager fileExistsAtPath:path]) {
        NSError *error;
        
        if (![self.fileManager removeItemAtPath:path error:&error]) {
            DDLogError(@"Failed to remove item at %@ due to error = %@", path, error);
        }
    }
    
    return path;
}

@end
