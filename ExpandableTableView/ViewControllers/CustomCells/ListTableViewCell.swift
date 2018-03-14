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
    
    func setupCellForExpand(listData:TableData, index:IndexPath){
        let content = listData.contentList?[index.row] ?? ""
    }
    
    func setupCellForCollapse(listData:TableData, index:IndexPath){
        let content = listData.contentList?[index.row] ?? ""
        self.contentTextView.textContainer.maximumNumberOfLines = 2;// set line length
        self.contentTextView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping // set line break mode
        self.contentTextView.font = UIFont.systemFont(ofSize: 14.0)
        self.contentTextView.setNeedsLayout()
        self.contentTextView.layoutIfNeeded()
        let (fitContent, isTrimmed, truncateTail) = StringContollers().stringVisibleIn(textView:self.contentTextView, content: content, truncateTail: "...readmore")
        
        let attributes = [
            NSAttributedStringKey.font : contentTextView.font ?? UIFont()]
        var contentText = NSMutableAttributedString()
        
        if isTrimmed{
//            let endIndex = fitContent.index(fitContent.endIndex, offsetBy:-13)
            contentText = NSMutableAttributedString(string:(String(fitContent)), attributes: attributes)
            
            let selectablePart = NSMutableAttributedString(string: truncateTail)
            selectablePart.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, selectablePart.length))
            
            // Add an NSLinkAttributeName with a value of an url or anything else
            selectablePart.addAttribute(NSAttributedStringKey.link, value: "action", range: NSMakeRange(0,selectablePart.length))
            
            // Combine the non-selectable string with the selectable string
            contentText.append(selectablePart)
            
        }else{
            contentText = NSMutableAttributedString(string:fitContent, attributes: attributes)
        }
        // Set the text view to contain the attributed text
        self.contentTextView.attributedText = contentText
        self.contentTextView.delegate = self
        self.contentTextView.tag = 13
        
        
//        self.contentTextView.text = fitContent
        print("maximum fit strings: ", contentText.string)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // **Perform sign in action here**
        print("buttoncClicked")
        return false
    }
}


