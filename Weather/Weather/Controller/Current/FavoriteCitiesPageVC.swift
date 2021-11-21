//
//  FavoriteCitiesPageVC.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class FavoriteCitiesPageVC: UIPageViewController {
    
    private var currentViewControllers: [CurrentLocationVC] = [CurrentLocationVC]()
    var startIndex: Int = 0
    var weatherList: [WeatherInfoModel] = [WeatherInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCurrentWeatherViewController()
        setupPageView()
        setupFirstPageView()
    }
    
    private func setupPageView() {
        dataSource = self
        delegate = self
    }
    
    private func createCurrentWeatherViewController() {
        var count = 0
        for i in weatherList {
            guard let eachPage = currentViewController() as? CurrentLocationVC else {
                return
            }
            eachPage.currentWeatherData = i
            eachPage.currentIndex = count
            eachPage.totalPage = weatherList.count
            currentViewControllers.append(eachPage)
            count += 1
        }
    }
    
    private func setupFirstPageView() {
        let firstViewController = currentViewControllers[startIndex]
        setViewControllers([firstViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil
        )
    }
    
    private func currentViewController() -> UIViewController {
        let st = UIStoryboard(name: "CurrentLocation", bundle: nil)
        return st.instantiateViewController(withIdentifier: "CurrentLocationVC")
    }
}

// MARK: UIPageViewControllerDataSource
extension FavoriteCitiesPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? CurrentLocationVC,
            let viewControllerIndex = currentViewControllers.firstIndex(of: current) else {
                return nil
        }
        
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0,
            currentViewControllers.count > previousIndex else {
            return nil
        }
        return currentViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? CurrentLocationVC,
            let viewControllerIndex = currentViewControllers.firstIndex(of: current) else {
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = currentViewControllers.count
        
        guard orderedViewControllersCount != nextIndex,
            orderedViewControllersCount > nextIndex else {
            return nil
        }
        return currentViewControllers[nextIndex]
    }
}

// MARK: UIPageViewControllerDelegate
extension FavoriteCitiesPageVC: UIPageViewControllerDelegate {}

