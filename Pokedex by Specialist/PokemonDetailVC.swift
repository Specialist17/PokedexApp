//
//  PokemonDetailVC.swift
//  Pokedex by Specialist
//
//  Created by Fernando on 11/8/15.
//  Copyright © 2015 Fernando. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvo: UIImageView!
    @IBOutlet weak var nextEvo: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonName.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvo.image = img
        
        pokemon.downloadPokemonDetails{ () -> () in
            //this will be called after download is done
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.pokeDescription
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLb.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.attack
        pokedexLbl.text = "\(pokemon.pokedexId)"
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "NO EVOLUTION"
            nextEvo.hidden = true
        }else{
            nextEvo.hidden = false
            nextEvo.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
        
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
