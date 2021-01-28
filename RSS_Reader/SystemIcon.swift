//
//  Icon.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

enum SystemIcon {
    /// SideMenuView
    case infinity
    /// MainView
    case side_menu
    case hide_read
    case show_read
    case settings
    case share
    case search
    case casing_sensitive
    case casing_insensitive
    /// settings
    case feed_settings
    case collection_settings
    case auto_refresh
    case theme
    case square_dashed
    case square
    case square_rounded
    case circle
    case image_style
    case icon_size
    /// several occurences
    case add
    case trash
    case folder
    case edit
    case check
    case xmark
    case minus
    case plus
    case circle_small
    case close
    case forward
    case bookmark
    case unmark

    
    var name: String {
        var str: String? = nil
        switch self {
        case .side_menu:
            str = "line.horizontal.3"
        case .infinity:
            str = "infinity"
        case .bookmark:
            str = "bookmark.fill"
        case .unmark:
            str = "bookmark"
        case .hide_read:
            str = "eye.fill"
        case .show_read:
            str = "eye"
        case .settings:
            str = "gearshape.fill"
        case .share:
            str = "square.and.arrow.up"
        case .search:
            str = "magnifyingglass"
        case .casing_sensitive:
            str = "textformat"
        case .casing_insensitive:
            str = "textformat.size.larger"
        case .feed_settings:
            str = "wave.3.right"
        case .collection_settings:
            str = "rectangle.fill.on.rectangle.fill"
        case .auto_refresh:
            str = "arrow.clockwise"
        case .theme:
            str = "moon.fill"
        case .add:
            str = "plus"
        case .trash:
            str = "trash.fill"
        case .folder:
            str = "folder.fill"
        case .edit:
            str = "pencil"
        case .check:
            str = "checkmark"
        case .xmark:
            str = "xmark.circle.fill"
        case .minus:
            str =  "minus.circle.fill"
        case .plus:
            str = "plus.circle.fill"
        case .circle_small:
            str = "circle.fill"
        case .close:
            str = "xmark"
        case .forward:
            str = "chevron.forward"
        case .square_dashed:
            str = "square.dashed"
        case .square:
            str = "squareshape"
        case .square_rounded:
            str = "square"
        case .circle:
            str = "circle"
        case .image_style:
            str = "cursorarrow.and.square.on.square.dashed"
        case .icon_size:
            str = "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
        }
        return str!
    }
}
