//import SwiftUI
//import UIKit
//
//struct PageViewController: UIViewControllerRepresentable {
//    var views: [UIViewController]
//    @Binding var currentIndex: Int
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIPageViewController {
//        let pageViewController = UIPageViewController(
//            transitionStyle: .scroll,
//            navigationOrientation: .horizontal,
//            options: nil
//        )
//        pageViewController.dataSource = context.coordinator
//        pageViewController.delegate = context.coordinator
//
//        if !views.isEmpty {
//            pageViewController.setViewControllers(
//                [views[currentIndex]],
//                direction: .forward,
//                animated: false
//            )
////        }
//
//        return pageViewController
//    }
//
//    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
//        guard !views.isEmpty else { return }
//
//        // Ensure the current view is updated only if necessary
//        if let visibleViewController = pageViewController.viewControllers?.first,
//           let visibleIndex = views.firstIndex(of: visibleViewController),
//           visibleIndex != currentIndex {
//            let direction: UIPageViewController.NavigationDirection = currentIndex > visibleIndex ? .forward : .reverse
//            pageViewController.setViewControllers(
//                [views[currentIndex]],
//                direction: direction,
//                animated: true
//            )
//        }
//    }
//
//    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//        var parent: PageViewController
//
//        init(_ pageViewController: PageViewController) {
//            parent = pageViewController
//        }
//
//        func pageViewController(
//            _ pageViewController: UIPageViewController,
//            viewControllerBefore viewController: UIViewController
//        ) -> UIViewController? {
//            guard let index = parent.views.firstIndex(of: viewController), index > 0 else {
//                return nil
//            }
//            return parent.views[index - 1]
//        }
//
//        func pageViewController(
//            _ pageViewController: UIPageViewController,
//            viewControllerAfter viewController: UIViewController
//        ) -> UIViewController? {
//            guard let index = parent.views.firstIndex(of: viewController), index + 1 < parent.views.count else {
//                return nil
//            }
//            return parent.views[index + 1]
//        }
//
//        func pageViewController(
//            _ pageViewController: UIPageViewController,
//            didFinishAnimating finished: Bool,
//            previousViewControllers: [UIViewController],
//            transitionCompleted completed: Bool
//        ) {
//            if completed, let visibleViewController = pageViewController.viewControllers?.first,
//               let index = parent.views.firstIndex(of: visibleViewController) {
//                parent.currentIndex = index
//            }
//        }
//    }
//}
//
