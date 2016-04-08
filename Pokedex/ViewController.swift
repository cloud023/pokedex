//
//  ViewController.swift
//  Pokedex
//
//  Created by Mouse on 06/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var collectionView : UICollectionView!;
    @IBOutlet weak var searchPokemonBar: UISearchBar!
    var musicPlayer : AVAudioPlayer!;
    
    var pokemons = [Pokemon]();
    var filteredPokemon : [Pokemon]!;
    
    var inSearchMode = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self;
        collectionView.dataSource = self;
        searchPokemonBar.delegate = self;
        
        searchPokemonBar.returnKeyType = UIReturnKeyType.Done;
        
        initMusic();
        parsePokemonCSV();
    }
    
    func initMusic(){
        let path = NSBundle.mainBundle().pathForResource("pokemon_intro", ofType: "mp3")!;
        do{
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!);
            musicPlayer.prepareToPlay();
            musicPlayer.numberOfLoops = -1;
            musicPlayer.play();
        } catch let err as NSError{
            print(err.debugDescription);
        }
    }

    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!;
        do{
            let csv = try CSV(contentsOfURL: path);
            for row in csv.rows{
                let pokemon = Pokemon(name: row["identifier"]!, pokodexId: Int(row["id"]!)!);
                pokemons.append(pokemon);
            }
            
        }catch let err as NSError {
            print(err.debugDescription);
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count;
        }
        
        return pokemons.count;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let pokemon : Pokemon!;
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row];
        } else {
            pokemon = pokemons[indexPath.row];
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: pokemon);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let pokemonDetailVC = segue.destinationViewController as? PokemonDetailVC {
                pokemonDetailVC.pokemon = sender as! Pokemon;
            }
        }
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokeCell{
            
            if inSearchMode {
                cell.configureCell(filteredPokemon[indexPath.row]);
            }else{
                cell.configureCell(pokemons[indexPath.row]);
            }
            
            return cell;
        }else{
            return UICollectionViewCell();
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105);
    }
    
    @IBAction func btnSoundTapped(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop();
            sender.alpha = 0.2;
        }else{
            musicPlayer.play();
            sender.alpha = 1.0;
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true);
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchPokemonLower = searchPokemonBar.text?.lowercaseString where searchPokemonBar.text != ""{
            inSearchMode = true;
            filteredPokemon = pokemons.filter({$0.name.rangeOfString(searchPokemonLower) != nil});
        } else {
            inSearchMode = false;
            view.endEditing(true);
        }
        collectionView.reloadData();
    }
    
    
}

