//
//  Business.h
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Offer, Reward;

@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * facebookUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureUrlString;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSString * country;
@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *offers;
@property (nonatomic, retain) NSSet *rewards;
@property (nonatomic, retain) NSString *zip;
@end

@interface Business (CoreDataGeneratedAccessors)

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet *)values;
- (void)removeOffers:(NSSet *)values;

- (void)addRewardsObject:(Reward *)value;
- (void)removeRewardsObject:(Reward *)value;
- (void)addRewards:(NSSet *)values;
- (void)removeRewards:(NSSet *)values;

@end
