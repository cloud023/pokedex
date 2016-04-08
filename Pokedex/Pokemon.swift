//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mouse on 06/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name : String!;
    private var _pokedexId : Int!;
    private var _description = "";
    private var _type = "";
    private var _defense = "";
    private var _weight = "";
    private var _height = "";
    private var _baseAttack = "";
    private var _nextEvoTxt  = "";
    private var _nextEvoId  = "";
    private var _nextEvoLvl = "";
    
    private var _pokemonUrl : String!;
    
    var name : String{
        return _name;
    }
    
    var pokedexId : Int{
        return _pokedexId;
    }
    
    var description : String{
        return _description;
    }
    
    var type : String{
        return _type;
    }
    
    var defense : String {
        return _defense;
    }
    
    
    var weight: String{
        return _weight;
    }
    
    var baseAttack : String{
        return _baseAttack;
    }
    
    
    var nextEvoTxt : String {
        return _nextEvoTxt;
    }
    
    var nextEvoLvl : String {
        return _nextEvoLvl;
    }
    
    var nextEvoId : String {
        return _nextEvoId;
    }
    
    var height : String {
        return _height;
    }
        
    init(name: String, pokodexId : Int){
        self._name = name;
        self._pokedexId = pokodexId;
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/";
    }
    
    func getNextEvolutionText() -> String{
        
        if _nextEvoLvl != ""{
            return "Next Evolution : LVL - \(_nextEvoLvl)"
        }
        
        return "Next Evolution : \(_nextEvoTxt))";
    }
    
    func downloadPokemonDetails(completed : DownloadComplete){
        
        let url = NSURL(string: self._pokemonUrl)!;
        
        print(self._pokemonUrl);
        
        Alamofire.request(.GET, url).responseJSON {
            response in
            
            if let jsonDict = response.result.value as? Dictionary<String,AnyObject>  {
                
                if let def = jsonDict["defense"] as? Int{
                    self._defense = "\(def)";
                }
                
                if let atck = jsonDict["attack"] as? Int{
                    self._baseAttack = "\(atck)";
                }
                
                if let weight = jsonDict["weight"] as? String{
                    self._weight = weight;
                }
                
                if let height = jsonDict["height"] as? String{
                    self._height = height;
                }
                
                if let types = jsonDict["types"] as? [Dictionary<String,String>] {
                    
                    var pokeTypes = "";
                    for type in types{
                        if let typeName = type["name"]{
                            print(typeName);
                            pokeTypes += "/\(typeName.capitalizedString)";
                        }
                    }
                    self._type = pokeTypes;
                    
                }
                
                if let descriptions = jsonDict["descriptions"] as? [Dictionary<String,AnyObject>] {
                    
                    if let descResource = descriptions[0]["resource_uri"] as? String{
                        let descResourceUrl = NSURL(string: "\(URL_BASE)/\(descResource)")!;
                        Alamofire.request(.GET, descResourceUrl).responseJSON{
                            response in
                        
                            if let descriptionDict = response.result.value as? Dictionary<String,AnyObject>{
                                if let description = descriptionDict["description"] as? String{
                                    self._description = description;
                                }
                            }
                            
                            completed();
                        };
                    }
                }
                
                
                if let evolutions = jsonDict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String{
                        //Doesn't support mega evolutions right now?!
                        if to.rangeOfString("mega") == nil{
                            if let evoResource = evolutions[0]["resource_uri"] as? String{
                                let toEvoPokedexStr = evoResource.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "");
                                let toEvoPokedexId = toEvoPokedexStr.stringByReplacingOccurrencesOfString("/", withString: "");
                                self._nextEvoId = toEvoPokedexId;
                            }
                        }
                        self._nextEvoTxt = to;
                    }
                    
                    
                    if let nextEvoLvl = evolutions[0]["level"] as? Int {
                        self._nextEvoLvl = "\(nextEvoLvl)";
                    }
                    
                }
                
            }
            
        };
        
    }
    
    
}