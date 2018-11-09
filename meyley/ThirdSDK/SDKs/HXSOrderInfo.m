//
//  HXSOrderInfo.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSOrderInfo.h"
#import "HXDataFormatter.h"
#import "HXMacrosUtils.h"

@implementation HXSOrderItem

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dic, @"item_id")) {
            self.item_id = [dic objectForKey:@"item_id"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"rid")) {
            self.rid = [dic objectForKey:@"rid"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"type")) {
            self.type = [[dic objectForKey:@"type"] intValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"price")) {
            self.price = [dic objectForKey:@"price"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"quantity")) {
            self.quantity = [dic objectForKey:@"quantity"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"amount")) {
            self.amount = [dic objectForKey:@"amount"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"origin_price")) {
            self.origin_price = [dic objectForKey:@"origin_price"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"promotion_id")) {
            self.promotion_id = [dic objectForKey:@"promotion_id"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"promotion_type")) {
            self.promotion_type = [dic objectForKey:@"promotion_type"];
        }
        
        if(DIC_HAS_STRING(dic, @"promotion_label")) {
            self.promotion_label = [dic objectForKey:@"promotion_label"];
        }
        
        if(DIC_HAS_STRING(dic, @"name")) {
            self.name = [dic objectForKey:@"name"];
        }
        
        if(DIC_HAS_STRING(dic, @"image_small")) {
            self.image_small = [dic objectForKey:@"image_small"];
        }
        
        if(DIC_HAS_STRING(dic, @"image_medium")) {
            self.image_medium = [dic objectForKey:@"image_medium"];
        }
        
        if(DIC_HAS_STRING(dic, @"image_big")) {
            self.image_big = [dic objectForKey:@"image_big"];
        }
        
        if(DIC_HAS_STRING(dic, @"comment")) {
            self.comment = [dic objectForKey:@"comment"];
        }
        
        if(DIC_HAS_STRING(dic, @"comment_time")) {
            self.comment_time = [dic objectForKey:@"comment_time"];
        }
        
        // END
    }
    
    return self;
}

@end

@implementation HXSOrderInfo

- (id)initWithDictionary:(NSDictionary *)dic {
    if(self = [super init]) {
        if(DIC_HAS_STRING(dic, @"order_sn")) {
            self.order_sn = [dic objectForKey:@"order_sn"];
        }else {
            return nil;
        }
        
        if(DIC_HAS_NUMBER(dic, @"status")) {
            self.status = [[dic objectForKey:@"status"] intValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"type")) {
            self.type = [[dic objectForKey:@"type"] intValue];
        }
        
        if(DIC_HAS_STRING(dic, @"type_name")) {
            self.typeName = [dic objectForKey:@"type_name"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"source")) {
            self.source = [[dic objectForKey:@"source"] intValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"paytype")) {
            self.paytype = [[dic objectForKey:@"paytype"] intValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"paystatus")) {
            self.paystatus = [[dic objectForKey:@"paystatus"] intValue];
        }
        
        if(DIC_HAS_STRING(dic, @"pay_trade_no")) {
            self.pay_trade_no = [dic objectForKey:@"pay_trade_no"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"service_eva")) {
            self.service_eva = [dic objectForKey:@"service_eva"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"delivery_eva")) {
            self.delivery_eva = [dic objectForKey:@"delivery_eva"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"food_eva")) {
            self.food_eva = [dic objectForKey:@"food_eva"];
        }
        
        if(DIC_HAS_STRING(dic, @"evaluation")) {
            self.evaluation = [dic objectForKey:@"evaluation"];
        }
        
        if(DIC_HAS_STRING(dic, @"attach")) {
            self.attach = [dic objectForKey:@"attach"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"food_num")) {
            self.food_num = [dic objectForKey:@"food_num"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"food_amount")) {
            self.food_amount = [dic objectForKey:@"food_amount"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"delivery_fee")) {
            self.delivery_fee = [dic objectForKey:@"delivery_fee"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"discount")) {
            self.discount = [dic objectForKey:@"discount"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"order_amount")) {
            self.order_amount = [dic objectForKey:@"order_amount"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"add_time")) {
            self.add_time = [dic objectForKey:@"add_time"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"confirm_time")) {
            self.confirm_time = [dic objectForKey:@"confirm_time"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"send_time")) {
            self.send_time = [dic objectForKey:@"send_time"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"expect_date")) {
            self.expect_date = [dic objectForKey:@"expect_date"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"delivery_type")) {
            self.delivery_type = [dic objectForKey:@"delivery_type"];
        }
        
        if(DIC_HAS_STRING(dic, @"expect_timeslot")) {
            self.expect_timeslot = [dic objectForKey:@"expect_timeslot"];
        }
        
        if(DIC_HAS_STRING(dic, @"phone")) {
            self.phone = [dic objectForKey:@"phone"];
        }
        
        if(DIC_HAS_STRING(dic, @"address1")) {
            self.address1 = [dic objectForKey:@"address1"];
        }
        
        if(DIC_HAS_STRING(dic, @"address2")) {
            self.address2 = [dic objectForKey:@"address2"];
        }
        
        if(DIC_HAS_STRING(dic, @"coupon_code")) {
            self.coupon_code = [dic objectForKey:@"coupon_code"];
        }
        
        if(DIC_HAS_STRING(dic, @"remark")) {
            self.remark = [dic objectForKey:@"remark"];
        }
        
        if(DIC_HAS_STRING(dic, @"dormitory")) {
            self.dormitory = [dic objectForKey:@"dormitory"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"refund_status_code")) {
            self.refund_status_code = [dic objectForKey:@"refund_status_code"];
        }
        
        if(DIC_HAS_STRING(dic, @"refund_status_msg")) {
            self.refund_status_msg = [dic objectForKey:@"refund_status_msg"];
        }
        
        if(DIC_HAS_STRING(dic, @"dorm_contact")) {
            self.dorm_contact = [dic objectForKey:@"dorm_contact"];
        }
        
        self.features = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dic, @"features")) {
            self.features = [dic objectForKey:@"features"];
        }
        
        self.items = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dic, @"items")) {
            for(NSDictionary * itemDic in [dic objectForKey:@"items"]) {
                HXSOrderItem * item = [[HXSOrderItem alloc] initWithDictionary:itemDic];
                if(item) {
                    [self.items addObject:item];
                }
            }
        }
        
        self.promotion_items = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dic, @"promotion_items")) {
            for(NSDictionary * itemDic in [dic objectForKey:@"promotion_items"]) {
                HXSOrderItem * item = [[HXSOrderItem alloc] initWithDictionary:itemDic];
                if(item) {
                    [self.promotion_items addObject:item];
                }
            }
        }
        
        if (DIC_HAS_STRING(dic, @"icon")) {
            self.iconURLStr = [dic objectForKey:@"icon"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"comment_status")) {
            self.commentStatusIntNum = [dic objectForKey:@"comment_status"];
        }
        
        if (DIC_HAS_STRING(dic, @"consignee_name")) {
            self.consigneeNameStr = [dic objectForKey:@"consignee_name"];
        }
        
        if (DIC_HAS_STRING(dic, @"consignee_address")) {
            self.consigneeAddressStr = [dic objectForKey:@"consignee_address"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment")) {
            self.installmentIntNum = [dic objectForKey:@"installment"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"down_payment")) {
            self.downPaymentFloatNum = [dic objectForKey:@"down_payment"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment_amount")) {
            self.installmentAmountFloatNum = [dic objectForKey:@"installment_amount"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"repayment_amount")) {
            self.repaymentAmountFloatNum = [dic objectForKey:@"repayment_amount"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment_num")) {
            self.installmentNumIntNum = [dic objectForKey:@"installment_num"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"pay_time")) {
            NSNumber *timeNum = [dic objectForKey:@"pay_time"];
            NSTimeInterval timeInterval = [timeNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *dateStr = [HXDataFormatter stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
            
            self.payTimeStr = (0 < [dateStr length]) ? dateStr : @"";
        }
        
        if (DIC_HAS_NUMBER(dic, @"down_payment_type")) {
            self.downPaymentTypeIntNum = [dic objectForKey:@"down_payment_type"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment_type")) {
            self.installmentTypeIntNum = [dic objectForKey:@"installment_type"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"cancel_time")) {
            NSNumber *timeNum = [dic objectForKey:@"cancel_time"];
            NSTimeInterval timeInterval = [timeNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *dateStr = [HXDataFormatter stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];

            self.cacelTimeStr = (0 < [dateStr length]) ? dateStr : @"";
        }
        
        if (DIC_HAS_NUMBER(dic, @"comment_time")) {
            NSNumber *timeNum = [dic objectForKey:@"comment_time"];
            NSTimeInterval timeInterval = [timeNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *dateStr = [HXDataFormatter stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
            
            self.commentTimeStr = (0 < [dateStr length]) ? dateStr : @"";
        }
        // END
    }

    return self;
}

@end
