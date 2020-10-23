//
//  CMPDataStorageUserDefaults.h
//  GDPR
//

#import <Foundation/Foundation.h>
#import "SPTIabTCFv2StorageProtocol.h"

@interface SPTIabTCFv2StorageUserDefaults : NSObject<SPTIabTCFv2StorageProtocol>

@property (nonatomic, retain) NSUserDefaults *userDefaults;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefs
    NS_SWIFT_NAME(initWith(userDefaults:));

@end
