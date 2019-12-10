//
//  Course.m
//  ASFramework
//
//  Created by Anurag Sharma on 10/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

#import "Course.h"
#import <ASFramework/ASFramework-Swift.h>

@interface Course()
@property (nonatomic,strong,nonnull) NSMutableArray <Person *> *allRegisteredPersons;

@end

@implementation Course

-(instancetype)init{
    if (self=[super init]) {
        NSLog(@"Course Init Method");
        self.allRegisteredPersons = [NSMutableArray new];
    }
    
    return self;
}

-(void)registerPerson:(Person *)person{
    [self.allRegisteredPersons addObject:person];
}

-(nullable NSArray < Person *> *)persons
{
    if (self.allRegisteredPersons.count) {
        return self.allRegisteredPersons;
    }
    
    return nil;
}
@end
