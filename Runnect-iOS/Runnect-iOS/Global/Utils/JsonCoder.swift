//
//  JsonCoder.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import Foundation

/**

  - Description:
 
          JsonEncoder와 decoder를 편리하게 접근하는 용도입니다.
      'Json.decoder.decode'와 같이 호출 가능합니다.
          
*/

public enum Json {
    public static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    public static let decoder = JSONDecoder()
}
