//
//  TableContent+Operations.swift
//  ExpandableTableView
//
//  Created by user on 12/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import Foundation

extension TableData {
    public func getTableContentFromData(tableContentData:Any?) -> TableData {
        self.contentList = (tableContentData as? [String]) ?? []
        return self
    }
}
