//
//  PrivateNoteUITableViewCell.swift
//  PrivateNotes
//
//  Created by Luisa Cardona on 12/3/20.
//  Copyright © 2020 Luisa Cardona. All rights reserved.
//

import UIKit

class PrivateNoteUITableViewCell : UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
 
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
}
