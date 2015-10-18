#import "RTRecordVideoAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTRecordVideoViewController.h"
#import "RTRecordVideoWireframe.h"

@implementation RTRecordVideoAssembly

- (RTRecordVideoViewController *)recordVideoViewController {
    return [TyphoonDefinition withClass:[RTRecordVideoViewController class]];
}

- (RTRecordVideoWireframe *)recordVideoWireframe {
    return [TyphoonDefinition withClass:[RTRecordVideoWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self recordVideoViewController]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

@end
