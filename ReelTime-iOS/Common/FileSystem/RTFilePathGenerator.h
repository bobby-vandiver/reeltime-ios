#import <Foundation/Foundation.h>

@interface RTFilePathGenerator : NSObject

- (instancetype)initWithFileManager:(NSFileManager *)fileManager;

- (NSString *)tempFilePath:(NSString *)fileExtension;

@end
