#import <RestKit/RestKit.h>

@interface RKObjectManager (IncludeHeaders)

- (void)getObject:(id)object
             path:(NSString *)path
       parameters:(NSDictionary *)parameters
          headers:(NSDictionary *)headers
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
           failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;

- (void)deleteObject:(id)object
                path:(NSString *)path
          parameters:(NSDictionary *)parameters
             headers:(NSDictionary *)headers
             success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
             failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;

@end
