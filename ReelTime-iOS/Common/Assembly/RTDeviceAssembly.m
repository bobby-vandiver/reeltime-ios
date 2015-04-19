#import "RTDeviceAssembly.h"

#import "RTDeviceHardware.h"
#import "RTDeviceInformation.h"

#import "RTThumbnailSupport.h"

@implementation RTDeviceAssembly

- (RTDeviceHardware *)deviceHardware {
    return [TyphoonDefinition withClass:[RTDeviceHardware class]];
}

- (RTDeviceInformation *)deviceInformation {
    return [TyphoonDefinition withClass:[RTDeviceInformation class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDeviceHardware:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self deviceHardware]];
        }];
    }];
}

- (RTThumbnailSupport *)thumbnailSupport {
    return [TyphoonDefinition withClass:[RTThumbnailSupport class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDeviceInformation:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self deviceInformation]];
        }];
    }];
}

@end
