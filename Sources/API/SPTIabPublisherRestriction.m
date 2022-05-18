//
//  SPTIabPublisherRestriction.m
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 05/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import "SPTIabPublisherRestriction.h"

@implementation SPTIabPublisherRestriction

- (NSDictionary *)asJson {
    NSMutableDictionary * result = [NSMutableDictionary new];

    [result setValue:@(self.purposeId) forKey:@"purposeId"];
    [result setValue:@(self.restrictionType) forKey:@"restrictionType"];
    [result setValue:self.parsedVendors forKey:@"parsedVendors"];

    return result;
}

-(instancetype)init: (NSNumber*)purposeId
    restrictionType:(PublisherRestrictionType)restrictionType
          vendorIds:(NSArray *)vendorIds
      parsedVendors:(NSString * _Nullable)parsedVendors {
    self = [super init];
    if (self) {
        _purposeId = purposeId.intValue;
        _restrictionType = restrictionType;
        _vendorsIds = vendorIds;
        _parsedVendors = parsedVendors;
    }
    return self;
}

-(bool)isEqual:(id)object {
    SPTIabPublisherRestriction* obj = (SPTIabPublisherRestriction *)object;
    return self.purposeId == obj.purposeId &&
        self.restrictionType == obj.restrictionType &&
        self.vendorsIds == obj.vendorsIds &&
        self.parsedVendors == obj.parsedVendors;
}

- (NSString *)parsedVendors {
    NSMutableString *retString = [NSMutableString new];
    
    NSInteger maxId = [[self.vendorsIds valueForKeyPath:@"@max.self"] integerValue];
    NSString *typeString = [NSString stringWithFormat:@"%ld", (long)self.restrictionType];
    NSString *restrictionUndefinedString = [NSString stringWithFormat:@"%ld", (long)Restriction_Undefined];
    for (int i = 1 ; i <= (int)maxId ; i++) {
        if ([self.vendorsIds containsObject:[NSNumber numberWithInteger:i]]) {
            [retString appendString: typeString];
        } else {
            [retString appendString:restrictionUndefinedString];
        }
    }
    return retString;
}

@end
