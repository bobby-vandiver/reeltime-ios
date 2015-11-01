#import <Typhoon/Typhoon.h>

@class RTFilePathGenerator;

@interface RTCommonComponentsAssembly : TyphoonAssembly

- (NSNotificationCenter *)notificationCenter;

- (NSFileManager *)fileManager;

- (RTFilePathGenerator *)filePathGenerator;

@end
