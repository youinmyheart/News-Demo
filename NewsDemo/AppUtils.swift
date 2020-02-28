// 
// AppUtils.swift
// 
// Created on 2/29/20.
// 

import UIKit

class AppUtils: NSObject {

    public class func isEmptyString(_ str: String?) -> Bool {
        return (str ?? "").isEmpty
    }
    
    public class func log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line ) {
        #if DEBUG
        let className = file.components(separatedBy: "/").last
        var str = ""
        
        for (index, item) in items.enumerated() {
            str += String(describing: item)
            if index < items.count - 1 {
                str += separator
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let dateTime = formatter.string(from: Date())
        
        print("\(dateTime) [\(className ?? "")] [Line \(line)]", str, separator: separator, terminator: terminator)
        #endif
    }
}
