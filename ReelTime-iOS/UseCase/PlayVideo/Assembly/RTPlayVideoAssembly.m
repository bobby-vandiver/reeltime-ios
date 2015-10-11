#import "RTPlayVideoAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTServiceAssembly.h"
#import "RTCommonComponentsAssembly.h"

#import "RTPlayVideoWireframe.h"
#import "RTPlayVideoViewController.h"

#import "RTPlayerFactory.h"

#import "RTPlayVideoConnectionFactory.h"
#import "RTPlayVideoIdExtractor.h"

#import "RTPlayVideoURLProtocol.h"

@implementation RTPlayVideoAssembly

- (RTPlayVideoWireframe *)playVideoWireframe {
    return [TyphoonDefinition withClass:[RTPlayVideoWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTPlayVideoViewController *)playVideoViewControllerForVideoId:(NSNumber *)videoId {
    return [TyphoonDefinition withClass:[RTPlayVideoViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForVideoId:withPlayerFactory:notificationCenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:videoId];
            [initializer injectParameterWith:[self playerFactory]];
            [initializer injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
        }];
    }];
}

- (RTPlayerFactory *)playerFactory {
    return [TyphoonDefinition withClass:[RTPlayerFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithServerUrl:pathFormatter:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly baseUrl]];
            [method injectParameterWith:[self.clientAssembly endpointPathFormatter]];
        }];
    }];
}

- (RTPlayVideoConnectionFactory *)playVideoConnectionFactory {
    return [TyphoonDefinition withClass:[RTPlayVideoConnectionFactory class]];
}

- (RTPlayVideoIdExtractor *)playVideoIdExtractor {
    return [TyphoonDefinition withClass:[RTPlayVideoIdExtractor class]];
}

- (RTPlayVideoURLProtocol *)playVideoURLProtocolWithRequest:(NSURLRequest *)request
                                             cachedResponse:(NSCachedURLResponse *)cachedResponse
                                                     client:(id<NSURLProtocolClient>)client {
    return [TyphoonDefinition withClass:[RTPlayVideoURLProtocol class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithRequest:cachedResponse:client:currentUserService:connectionFactory:videoIdExtractor:authorizationHeaderSupport:notificationCenter:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:request];
                          [method injectParameterWith:cachedResponse];
                          [method injectParameterWith:client];
                          [method injectParameterWith:[self.serviceAssembly currentUserService]];
                          [method injectParameterWith:[self playVideoConnectionFactory]];
                          [method injectParameterWith:[self playVideoIdExtractor]];
                          [method injectParameterWith:[self.clientAssembly authorizationHeaderSupport]];
                          [method injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
        }];
    }];
}

@end
