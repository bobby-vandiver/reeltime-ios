#import <RestKit/RestKit.h>

typedef void (^Callback)(id);

typedef void (^RKSuccessCallback)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^RKFailureCallback)(RKObjectRequestOperation *operation, NSError *error);

typedef void (^RKHTTPOperation)(RKSuccessCallback successCallback, RKFailureCallback failureCallback);

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
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
     formDataBlock:(void (^)(id<AFMultipartFormData>))formDataBlock
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)deleteObject:(id)object
                path:(NSString *)path
          parameters:(NSDictionary *)parameters
             headers:(NSDictionary *)headers
             success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
             failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
