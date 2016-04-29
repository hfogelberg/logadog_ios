//: Playground - noun: a place where people can play

import Cocoa
import Foundation


let config = NSURLSessionConfiguration.defaultSessionConfiguration()
let userPasswordString = "username@gmail.com:password"
let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
let authString = "Basic \(base64EncodedCredential)"
config.HTTPAdditionalHeaders = ["Authorization" : authString]
let session = NSURLSession(configuration: config)

var running = false
let url = NSURL(string: "https://example.com/api/v1/records.json")
let task = session.dataTaskWithURL(url!) {
    (let data, let response, let error) in
    if let httpResponse = response as? NSHTTPURLResponse {
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print(dataString)
    }
    running = false
}

running = true
task.resume()

while running {
    print("waiting...")
    sleep(1)
}