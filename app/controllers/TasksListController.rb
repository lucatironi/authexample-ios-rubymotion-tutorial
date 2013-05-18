class TasksListController < UIViewController
  attr_accessor :tasks

  def self.controller
    @controller ||= TasksListController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.tasks = []

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
    newTaskButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,
                                                                      target:self,
                                                                      action:'addNewTask')
    self.navigationItem.rightBarButtonItems = [refreshButton, newTaskButton]


    @tasksTableView = UITableView.alloc.initWithFrame([[0, 0],
                                                      [self.view.bounds.size.width, self.view.bounds.size.height]],
                                                      style:UITableViewStylePlain)
    @tasksTableView.dataSource = self
    @tasksTableView.delegate = self
    @tasksTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    self.view.addSubview(@tasksTableView)

    refresh if App::Persistence['authToken']
  end

  # UITableView delegate methods
  def tableView(tableView, numberOfRowsInSection:section)
    self.tasks.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    task = self.tasks[indexPath.row]

    cell.textLabel.text = task.title

    if task.completed
      cell.textLabel.color = '#aaaaaa'.to_color
      cell.accessoryType = UITableViewCellAccessoryCheckmark
    else
      cell.textLabel.color = '#222222'.to_color
      cell.accessoryType = UITableViewCellAccessoryNone
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    task = self.tasks[indexPath.row]

    task.toggle_completed do
      refresh
    end
  end

  # Controller methods
  def refresh
    SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
    Task.all do |jsonTasks|
      self.tasks.clear
      self.tasks = jsonTasks
      @tasksTableView.reloadData
      SVProgressHUD.dismiss
    end
  end

  def addNewTask
    @newTaskController = NewTaskController.alloc.init
    @newTaskNavigationController = UINavigationController.alloc.init
    @newTaskNavigationController.pushViewController(@newTaskController, animated:false)

    self.presentModalViewController(@newTaskNavigationController, animated:true)
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end
end