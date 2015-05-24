typedef BOOL (^ValidationCallback)(NSDictionary *parameters, NSArray *__autoreleasing *errors);

typedef NSError * (^ErrorFactoryCallback)(NSInteger errorCode);
