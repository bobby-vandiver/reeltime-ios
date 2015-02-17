#import "RKObjectManager+IncludeHeaders.h"

@implementation RKObjectManager (IncludeHeaders)

- (void)getObject:(id)object
             path:(NSString *)path
       parameters:(NSDictionary *)parameters
          headers:(NSDictionary *)headers
          success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
          failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithObject:object
                                                    method:RKRequestMethodGET
                                                      path:path
                                                parameters:parameters];
    [self addHeaders:headers toRequest:request];
    [self enqueueRequest:request success:success failure:failure];
}

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
           failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithObject:object
                                                    method:RKRequestMethodPOST
                                                      path:path
                                                parameters:parameters];
    [self addHeaders:headers toRequest:request];
    [self enqueueRequest:request success:success failure:failure];
}

- (void)addHeaders:(NSDictionary *)headers
         toRequest:(NSMutableURLRequest *)request {
    for (NSString *header in [headers allKeys]) {
        id value = [headers objectForKey:header];
        [request setValue:value forHTTPHeaderField:header];
    }
}

- (void)enqueueRequest:(NSURLRequest *)request
               success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
               failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
    RKObjectRequestOperation *operation = [self objectRequestOperationWithRequest:request
                                                                          success:success
                                                                          failure:failure];
    [self enqueueObjectRequestOperation:operation];
}

@end
