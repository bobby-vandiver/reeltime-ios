#import <Typhoon/Typhoon.h>

@class RTClient;
@class RTServerErrorsConverter;

@interface RTClientAssembly : TyphoonAssembly

- (RTClient *)reelTimeClient;

- (RTServerErrorsConverter *)serverErrorsConverter;

@end
