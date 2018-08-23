//
//  Communicate.m
//  Metal Prints
//
//  Created by Bryan Stevens on 7/27/18.
//  Copyright © 2018 Pocket Tools. All rights reserved.
//

#import "Communicate.h"

@interface Communicate ()

@end

@implementation Communicate{
    NSURLConnection *connectionManager;
}

-(NSString*)authenticate{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/authenticate.php"]];
    NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"8w0eF7uBgx5e2azW0714p5IQVKuF8c95",@"key",nil];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:cartItem options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    NSString *token;
    
    if(responseString)
    {
        //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
        NSLog(@"got response==%@", responseString);
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSString *successString = [json objectForKey:@"status"];
        if ([successString isEqualToString:@"success"]) {
            token = [json objectForKey:@"token"];
            return token;
        }
        
    }
    return token;
}

-(void)launched:(NSString*)token{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/analytics.php"]];
    NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"appLaunch",@"type",token,@"token",nil];
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:cartItem options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSString *successString = [json objectForKey:@"status"];
        //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
        NSLog(@"got response==%@", responseString);
        
    }
}

-(NSArray*)stripeCharge:(NSDictionary*)params{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/stripeStuff.php"]];
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error2];
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    if(responseString)
    {
        NSLog(@"Here");
        NSLog(@"%@",responseString);
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSLog(@"%@",json);
        NSString *successString = [json objectForKey:@"status"];
        if ([successString isEqualToString:@"succeeded"]) {
            

            NSArray *idArray = @[[json objectForKey:@"stripeChargeID"],[json objectForKey:@"customerID"]];
            NSArray *orderAttemptArray = @[@"charge successful",@"upload not attempted"];
            [NSKeyedArchiver archiveRootObject:orderAttemptArray toFile:[self archiveOrderAttemp]];
            
            return idArray;
        }
        else{
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:[self archiveOrderAttemp] error:&error];
            return nil;
        }
    }
    else{
        NSLog(@"Error!");
        return nil;
    }
}

-(BOOL)postData:(NSMutableDictionary*)params withDelegate:(PaymentVC*)theDelegate{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/recieve_data.php"]];
    NSError *error2;
    //NSLog(@"Posted Data:%@",params);
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    //connectionManager = [[NSURLConnection alloc] initWithRequest:request delegate:theDelegate];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"File size is : %.2f MB",(float)responseData.length/1024.0f/1024.0f);
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
        NSLog(@"got response==%@", responseString);
        //[self sendEmail];
        return YES;
        
        
    }
    else
    {
        NSLog(@"faield to connect");
        
        return NO;
        
    }
}

-(BOOL)supportMessageSent:(NSString *)token{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/analytics.php"]];
    NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"support",@"type",token,@"token",nil];
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:cartItem options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        NSLog(@"got response==%@", responseString);
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSString *successString = [json objectForKey:@"status"];
        if ([successString isEqualToString:@"success"]) {
            return YES;
        }else{
            return NO;
        }
    }
    else{
        return  NO;
    }
}

- (NSString*)archiveOrderAttemp{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"orderAttempt"];
}

@end
