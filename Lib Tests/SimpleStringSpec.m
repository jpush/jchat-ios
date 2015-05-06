////
////  Lib_Tests.m
////  Lib Tests
////
////  Created by zhang on 15/3/30.
////  Copyright (c) 2015年 Apple. All rights reserved.
////
//
////#import <Kiwi/Kiwi.h>
//#import "Kiwi.h"
//
////VVStack.h
//@interface VVStack : NSObject
//- (void)push:(double)num;
//- (double)pop;
//- (double)top;
//- (NSUInteger)count;
//@end
//
////VVStack.m
//@interface VVStack()
//@property (nonatomic, strong) NSMutableArray *numbers;
//@end
//
//@implementation VVStack
//- (id)init {
//    if (self = [super init]) {
//        _numbers = [NSMutableArray new];
//    }
//    return self;
//}
//
//- (void)push:(double)num {
//    [self.numbers addObject:@(num)];
//}
//
//- (double)top {
//    return [[self.numbers lastObject] doubleValue];
//}
//
//- (double)pop {
//    if ([self count] == 0) {
//        [NSException raise:@"VVStackPopEmptyException" format:@"Can not pop an empty stack."];
//    }
//    double result = [self top];
//    [self.numbers removeLastObject];
//    return result;
//}
//
//- (NSUInteger)count {
//    return [self.numbers count];
//}
//
//@end
//
//SPEC_BEGIN(SimpleSpec)
//
//describe(@"VVStack", ^{
//    context(@"when created", ^{
//        __block VVStack *stack = nil;
//        beforeEach(^{
//            stack = [VVStack new];
//        });
//        
//        afterEach(^{
//            stack = nil;
//        });
//        
//        it(@"should have the class VVStack", ^{
//            [[[VVStack class] shouldNot] beNil];
//        });
//        
//        it(@"should exist", ^{
//            [[stack shouldNot] beNil];
//        });
//        
//        it(@"should be able to push and get top", ^{
//            [stack push:2.3];
//            [[theValue([stack top]) should] equal:theValue(2.3)];
//            
//            [stack push:4.6];
//            [[theValue([stack top]) should] equal:4.6 withDelta:0.001];
//        });
//        
//        it(@"should equal contains 0 element", ^{
//            [[theValue([stack count]) should] beZero];
//        });
//        
//        context(@"when new created and pushed 4.6", ^{
//            __block VVStack *stack = nil;
//            beforeEach(^{
//                stack = [VVStack new];
//                [stack push:4.6];
//            });
//            
//            afterEach(^{
//                stack = nil;
//            });
//            
//            it(@"can be poped and the value equals 4.6", ^{
//                [[theValue([stack pop]) should] equal:theValue(4.6)];
//            });
//            
//            it(@"should contains 0 element after pop", ^{
//                [stack pop];
//                [[stack should] beEmpty];
//            });
//            it(@"should raise a exception when pop", ^{
//                [[theBlock(^{
//                    [stack pop];
//                }) should] raiseWithName:@"VVStackPopEmptyException"];
//            });
//        });
//    });
//});
//
//SPEC_END
