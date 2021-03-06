//
//  Pokemon.swift
//  Pokedex by Specialist
//
//  Created by Fernando on 11/8/15.
//  Copyright © 2015 Fernando. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _weight: String!
    private var _height: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    var pokeDescription: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var weight: String{
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var attack: String{
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionId: String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String{
        get{
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionText: String{
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonURL)!
        
        Alamofire.request(.GET, url).responseJSON{ response in
            
            let result = response.result
//            print(response.result) //SUCCESS
            
//            if let JSON = response.result.value {
//                
//                print("JSON: \(JSON)") //prints the value of the result
//            }
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    //print(types.debugDescription)
                    if let type = types[0]["name"]{
                        self._type = type.capitalizedString
                    }
                    
                    if types.count > 1{
                        for var x = 1; x<types.count; x++ {
                            if let type = types[x]["name"]{
                                self._type! += "/\(type.capitalizedString)"
                            }
                        }
                    }
                    
                }else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url2 = descArr[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)/\(url2)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                        
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                                
                            }
                            
                            completed()
                        }
                    }
                    
                }else{
                    self._description = "failed"
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String{
                        
                        // Can't support mega pokemon right now
                        // api still has mega data
                        if to.rangeOfString("mega") == nil{
                            if let str = evolutions[0]["resource_uri"] as? String{
                                
                                let newStr = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let lvl = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionText)
                            }
                        }
                        
                    }
                    
                }
                
            }// Main dictionary closing tag (if let dict = result.value as? Dictionary<String, AnyObject>)
        }// main alamofire request closing tag
    }// func downloadPokemonDetails closing tag
}