//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Mouse on 07/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon : Pokemon!;
    
    @IBOutlet weak var pokemonMainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokeIndexLbl: UILabel!
    
    @IBOutlet weak var baseAttacklbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var evoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemon.downloadPokemonDetails {
            self.updateUI();
        }
    }
    
    func updateUI(){
        pokemonMainImg.image = UIImage(named: "\(pokemon.pokedexId)");
        descriptionLbl.text = pokemon.description;
        typeLbl.text = pokemon.type;
        defenseLbl.text = pokemon.defense;
        heightLbl.text = pokemon.height;
        weightLbl.text = pokemon.weight;
        pokeIndexLbl.text = "\(pokemon.pokedexId)";
        baseAttacklbl.text = pokemon.baseAttack;
        nextEvoLbl.text = pokemon.getNextEvolutionText();
        nextEvoImg.image = UIImage(named: "\(pokemon.nextEvoId)");
        evoImg.image = UIImage(named: "\(pokemon.pokedexId)");
    }
    
}
