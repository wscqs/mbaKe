//
//  SaveCourseModel.swift
//
//  Created by mba on 17/2/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class SaveCourseModel: BaseModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSaveCourseModelStateKey: String = "state"
  private let kSaveCourseModelCidKey: String = "cid"

  // MARK: Properties
  public var state: String?
  public var cid: String?
    
    public required init?(map: Map) {
        super.init(map: map)
    }

  /**
  Map a JSON object to this class using ObjectMapper
   - parameter map: A mapping from ObjectMapper
  */
  public override func mapping(map: Map) {
    super.mapping(map: map)
    state <- map[kSaveCourseModelStateKey]
    cid <- map[kSaveCourseModelCidKey]
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[kSaveCourseModelStateKey] = value }
    if let value = cid { dictionary[kSaveCourseModelCidKey] = value }
    return dictionary
  }

}
