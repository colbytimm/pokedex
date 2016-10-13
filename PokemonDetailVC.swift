//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Colby Timm on 2016-10-13.
//  Copyright © 2016 Colby Timm. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }

}
