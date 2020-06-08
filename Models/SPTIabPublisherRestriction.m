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
    [result setValue:@(self.retrictionType) forKey:@"retrictionType"];
    [result setValue:self.parsedVendors forKey:@"parsedVendors"];

    return result;
    
}

@end
