//
//  PokeCellCollectionViewCell.swift
//  Pokedex
//
//  Created by Mouse on 06/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImg : UIImageView!;
    @IBOutlet weak var pokeNameLbl : UILabel!;
    
    var pokemon : Pokemon!;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        layer.cornerRadius = 5.0;
    }
    
    func configureCell(pokemon : Pokemon){
        pokeNameLbl.text = pokemon.name.capitalizedString;
        pokeImg.image = UIImage(named: "\(pokemon.pokedexId).png");
    }
}
