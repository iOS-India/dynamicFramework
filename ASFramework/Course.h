//
//  Course.h
//  ASFramework
//
//  Created by Anurag Sharma on 10/12/19.
//  Copyright © 2019 AnuragSharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
/*
 __covariant is to indicate that subtypes are acceptable, and __contravariant to indicate that supertypes are acceptable.
 */
@interface Course<__covariant T: Person*> : NSObject

-(void)registerPerson:(Person *_Nonnull)person;
-(nullable NSArray <T>*)persons;
@end

