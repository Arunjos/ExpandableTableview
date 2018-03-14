//
//  StringControllers.swift
//  ExpandableTableView
//
//  Created by user on 13/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import Foundation
import UIKit

class StringContollers{
    
    func stringVisibleIn(textView:UITextView, content:String, truncateTail:String) -> (String, Bool, String){
        // get textview font and line break mode
        let font = textView.font;
        let lineBreakMode = textView.textContainer.lineBreakMode;
        
        // get textViewContentWidth by neglecting lineFragmentPadding
        let textViewContentWidth = textView.frame.size.width - (textView.textContainer.lineFragmentPadding * 2)
        
        // get textViewContentheight take line height if line-limit is set else textviews height
        var textViewContentHeight:CGFloat = 0
        if textView.textContainer.maximumNumberOfLines != 0{
             textViewContentHeight = (textView.font?.lineHeight)! *  CGFloat(textView.textContainer.maximumNumberOfLines)
        }else{
             textViewContentHeight = textView.frame.size.width
        }
       
        // define size constraint as maximum height
        let sizeConstraint = CGSize(width: textViewContentWidth, height: CGFloat.greatestFiniteMagnitude)
       
        // set textfield attributes to content text
        let attributes = [
            NSAttributedStringKey.font : font ?? UIFont()]
        let attributedText = NSAttributedString(string: content, attributes: attributes)
        
        // find actual size for whole content
        let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        // Compare the actual height for whole content with the limited height
            // if it is less then the whole text will return
            // else go to the algroithm to find text which fits textview
        if (boundingRect.size.height > textViewContentHeight)
        {
            var index = content.startIndex // used to store indexes of whitespacesAndNewlines characters, intitialse it with start index
            var prev = content.startIndex //store previous whitespacesAndNewlines character index
            let characterSet = NSCharacterSet.whitespacesAndNewlines;
            var contentWithTruncateTail:String = ""
            repeat{
                
                prev = index;
                if lineBreakMode == NSLineBreakMode.byCharWrapping{// if lineBreakmode is  CharWrap then need to go for all indexes in content, makes algorithm a little bit heavy
                    index = content.index(after: index);
                }
                else{ // can make it more effiecnt if it is wordwrap, index can jump into next word seprator
                    let stringIndexRange = content.rangeOfCharacter(from: characterSet, options: String.CompareOptions(rawValue: 0), range:(index ..< content.endIndex))
                    if let stringIndexRange = stringIndexRange{
                        index = stringIndexRange.upperBound
                    }
                }
                contentWithTruncateTail = String(content[..<index]) + truncateTail//add truncate tail
            }
                while ((index < content.endIndex) && ( contentWithTruncateTail.boundingRect(with: sizeConstraint, options:NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                               attributes:attributes,
                                                                                               context: nil).size.height <= textViewContentHeight)); // getout from loop if heght exceeds limited height
            
            return (String(content[..<prev]), true, truncateTail); // return the string until previous index
        }
        return (content, false, ""); // return full content
    }
}
