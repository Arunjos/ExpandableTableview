//
//  ListTableViewCell.swift
//  ExpandableTableView
//
//  Created by user on 12/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: properties
    @IBOutlet weak var contentTextView: UITextView!
    var readMoreActionHandler:((Int) -> ())?
    var hideActionHandler:((Int) -> ())?
    
    //MARK: default methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: setup cell methods
    func setupCellForExpand(listData:TableData, index:Int){
        let content = listData.contentList?[index] ?? ""
        self.contentTextView.textContainer.maximumNumberOfLines = 0;// set line length
        self.contentTextView.attributedText = NSAttributedString(string:"")
        
        let attributes = [
            NSAttributedStringKey.font : contentTextView.font ?? UIFont()]
        let contentText = NSMutableAttributedString(string:content, attributes: attributes)
        let selectablePart = NSMutableAttributedString(string: Constants.CONTENTCELL.HIDE_TAIL, attributes: attributes)
        selectablePart.addAttribute(NSAttributedStringKey.link, value: Constants.CONTENTCELL.HIDE_ACTION, range: NSMakeRange(0,selectablePart.length))
        contentText.append(selectablePart)
        self.contentTextView.attributedText = contentText
        self.contentTextView.delegate = self
        self.contentTextView.tag = index
        
    }
    
    func setupCellForCollapse(listData:TableData, index:Int){
        let content = listData.contentList?[index] ?? ""
        self.contentTextView.textContainer.maximumNumberOfLines = Constants.CONTENTCELL.MAX_NUM_LINES;// set line length
        self.contentTextView.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping // set line break mode
        let (fitContent, isTrimmed, truncateTail) = StringContollers().stringVisibleIn(textView:self.contentTextView, content: content, truncateTail: Constants.CONTENTCELL.READMORE_TAIL)
        
        let attributes = [
            NSAttributedStringKey.font : contentTextView.font ?? UIFont()]
        var contentText = NSMutableAttributedString()
        
        if isTrimmed{
//            let endIndex = fitContent.index(fitContent.endIndex, offsetBy:-13)
            contentText = NSMutableAttributedString(string:(String(fitContent)), attributes: attributes)
            
            let selectablePart = NSMutableAttributedString(string: truncateTail, attributes: attributes)
            
            // Add an NSLinkAttributeName with a value of an url or anything else
            selectablePart.addAttribute(NSAttributedStringKey.link, value: Constants.CONTENTCELL.READMORE_ACTION, range: NSMakeRange(0,selectablePart.length))
            
            // Combine the non-selectable string with the selectable string
            contentText.append(selectablePart)
            
        }else{
            contentText = NSMutableAttributedString(string:fitContent, attributes: attributes)
        }
        // Set the text view to contain the attributed text
        self.contentTextView.attributedText = contentText
        self.contentTextView.delegate = self
        self.contentTextView.tag = index
        
    }
    
    //MARK: textview delegate
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if url == URL(string:Constants.CONTENTCELL.READMORE_ACTION){
            self.readMoreActionHandler?(textView.tag)
        }else if url == URL(string:Constants.CONTENTCELL.HIDE_ACTION){
            self.hideActionHandler?(textView.tag)
        }
        print("buttoncClicked at index: ", textView.tag)
        return false
    }
    
}


