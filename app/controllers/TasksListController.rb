class TasksListController < UIViewController

  def self.controller
    @controller ||= TasksListController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Tasks"
    self.view.backgroundColor = UIColor.whiteColor

    logoutButton = UIBarButtonItem.alloc.initWithTitle("Logout",
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:'logout')
    self.navigationItem.leftBarButtonItem = logoutButton

    refreshButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                      target:self,
                                                                      action:'refresh')
    self.navigationItem.rightBarButtonItem = refreshButton
  end

  def refresh
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end
end