#import "RTDeviceRegistrationAssembly.h"

#import "RTApplicationAssembly.h"
#import "RTLoginAssembly.h"

#import "RTDeviceRegistrationWireframe.h"
#import "RTDeviceRegistrationViewController.h"

@implementation RTDeviceRegistrationAssembly

- (RTDeviceRegistrationWireframe *)deviceRegistrationWireframe {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:loginWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self deviceRegistrationViewController]];
                          [method injectParameterWith:[self.loginAssembly loginWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTDeviceRegistrationViewController *)deviceRegistrationViewController {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationViewController class]];
}

@end
