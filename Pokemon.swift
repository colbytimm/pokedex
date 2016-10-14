//
//  Pokemon.swift
//  pokedex
//
//  Created by Colby Timm on 2016-10-12.
//  Copyright © 2016 Colby Timm. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defence: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        
        return _nextEvolutionLvl
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var defence: String {
        if _defence == nil {
            _defence = ""
        }
        
        return _defence
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var weight: String {
    if _weight == nil {
        _weight = ""
    }
    
    return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defence = "\(defense)"
                }
                
                if let typesList = dict["types"] as? [Dictionary<String, String>] , typesList.count > 0 {
                    var count = 0
                    var names = ""
                    
                    for type in typesList {
                        
                        if let name = type["name"] {
                            
                            //Add the comma delimiter between types
                            if count > 0 {
                                names += ", "
                            }
                            
                            names += name.capitalized
                            count += 1
                        }
                    }
                    
                    self._type = names
                    
                    if let descArray = dict["descriptions"] as? [Dictionary<String, String>] , descArray.count > 0 {
                        
                        if let url = descArray[0]["resource_uri"] {
                            
                            let descURL = "\(URL_BASE)\(url)"
                            
                            Alamofire.request(descURL).responseJSON(completionHandler: {(response) in
                                if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        
                                        let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                        
                                        self._description = newDescription
                                    }
                                }
                                
                                completed()
                        
                            })
                        }
                        
                    } else {
                        self._description = ""
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                        
                        if let nextEvo = evolutions[0]["to"] as? String {
                            
                            if nextEvo.range(of: "mege") == nil {
                                
                                self._nextEvolutionName = nextEvo
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvolutionId = nextEvoId
                                    
                                    if let lvlExist = evolutions[0]["level"] {
                                        
                                        if let lvl = lvlExist as? Int {
                                            
                                            self._nextEvolutionLvl = "\(lvl)"
                                        }
                                        
                                    } else {
                                        self._nextEvolutionLvl = ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            completed()
            
        }
        
    }
    
    
}











