//
//  ListTableViewCell.swift
//  ExpandableTableView
//
//  Created by user on 12/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import UIKit

enum ContentState {
    case collapse
    case expand
    case normal
}

class ListTableViewCell: UITableViewCell, UITextViewDelegate {
    
    
    @IBOutlet weak var contentTextView: UITextView!
    var contentState:ContentState = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView(content:String){
        
        self.contentTextView.textContainer.maximumNumberOfLines = 3;// set line length
        self.contentTextView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        
//        let text = NSMutableAttributedString(string:content)
//        text.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, text.length))
//
//        let selectablePart = NSMutableAttributedString(string: "readmore")
//        selectablePart.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, selectablePart.length))
//
//        // Add an underline to indicate this portion of text is selectable (optional)
//        selectablePart.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSMakeRange(0,selectablePart.length))
//        selectablePart.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor.black, range: NSMakeRange(0, selectablePart.length))
//
//        // Add an NSLinkAttributeName with a value of an url or anything else
//        selectablePart.addAttribute(NSAttributedStringKey.link, value: "action", range: NSMakeRange(0,selectablePart.length))
//
//        // Combine the non-selectable string with the selectable string
//        text.append(selectablePart)
//
//        // Set the text view to contain the attributed text
//        self.contentTextView.attributedText = text
//        self.contentTextView.delegate = self
//        self.contentTextView.tag = 13
        self.contentTextView.text = self.getFitString(content: content, textView: self.contentTextView)
        print("maximum fit strings: ", self.getFitString(content: content, textView: self.contentTextView))
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // **Perform sign in action here**
        
        return false
    }
    
    func getFitString(content:String, textView:UITextView) -> String{
        
        let font = textView.font;
        let lineBreakMode = textView.textContainer.lineBreakMode;
        
        let textViewWidth = textView.frame.size.width - (textView.textContainer.lineFragmentPadding * 2)
        let textViewHeight = textView.frame.size.height
        
        let sizeConstraint = CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes = [
            NSAttributedStringKey.font : font ?? UIFont()]
        let attributedText = NSAttributedString(string: content, attributes: attributes)
        
        let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if (boundingRect.size.height > textViewHeight)
        {
            var index = content.startIndex
            var prev = content.startIndex
            let characterSet = NSCharacterSet.whitespacesAndNewlines;
            
            repeat{
                
                prev = index;
                if lineBreakMode == NSLineBreakMode.byCharWrapping{
                    index = content.index(after: index);
                }
                else{
                    let stringIndexRange = content.rangeOfCharacter(from: characterSet, options: String.CompareOptions(rawValue: 0), range:(index ..< content.endIndex))
                    if let stringIndexRange = stringIndexRange{
                        index = stringIndexRange.upperBound
                    }
                }
            }
                while ((index <= content.endIndex) && ( String(content[..<index]).boundingRect(with: sizeConstraint, options:NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                               attributes:attributes,
                                                                                               context: nil).size.height <= textViewHeight));
            
            return String(content[..<prev]);
        }
        
        return content;
    }
}


