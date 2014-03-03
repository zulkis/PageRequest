//
//  Requesting.h
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#ifndef UberLoop_Requesting_h
#define UberLoop_Requesting_h

@protocol Requesting <NSObject>

@required

+ (void)updateModelFromPath:(NSString*)path
                 withParams:(NSDictionary*)params
                  inContext:(NSManagedObjectContext*)context
                 completion:(void(^)(NSError* error))completion;

@end

#endif
