//
//  Errors.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 15.12.20.
//

import Foundation


/**
 enum to throw errors
 */
enum ModelErrors: Error{
    case WrongDataType(_ error_msg: String)
}
