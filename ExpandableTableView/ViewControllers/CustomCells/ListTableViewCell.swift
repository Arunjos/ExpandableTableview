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
        
        self.contentTextView.textContainer.maximumNumberOfLines = 2;// set line length
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
        self.contentTextView.text = content
        self.contentTextView.setNeedsLayout()
        self.contentTextView.layoutIfNeeded()
        let (fitContent, isTrimmed) = StringContollers().stringVisibleIn(textView:self.contentTextView, content: content)
        self.contentTextView.text = fitContent
        print("maximum fit strings: ", fitContent)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // **Perform sign in action here**
        
        return false
    }
}


