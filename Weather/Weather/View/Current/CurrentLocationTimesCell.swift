//
//  CurrentLocationTimesCell.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class CurrentLocationTimesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var weatherList: [Weather] = [Weather]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        registerNib()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerNib() {
        collectionView.register(TimesCollectionCell.self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CurrentLocationTimesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesCollectionCell.reuseIdentifier, for: indexPath) as? TimesCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.config(weather: weatherList[indexPath.row])
        return cell
    }
}

