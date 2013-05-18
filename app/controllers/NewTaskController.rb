class NewTaskController < Formotion::FormController
  def init
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          title: "Title",
          key: :title,
          placeholder: "Task title",
          type: :string,
          auto_correction: :yes,
          auto_capitalization: :none
        }],
      }, {
        rows: [{
          title: "Save",
          type: :submit,
        }]
      }]
    })
    form.on_submit do
      self.createTask
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super

    self.title = "New Task"

    cancelButton = UIBarButtonItem.alloc.initWithTitle("Cancel",
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:'cancel')
    self.navigationItem.rightBarButtonItem = cancelButton
  end

  def createTask
    title = form.render[:title]
    if title.strip == ""
      App.alert("Please enter a title for the task.")
    else
      taskParams = { task: { title: title } }

      SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
      Task.create(taskParams) do |json|
        App.alert(json['info'])
        self.navigationController.dismissModalViewControllerAnimated(true)
        TasksListController.controller.refresh
        SVProgressHUD.dismiss
      end
    end
  end

  def cancel
    self.navigationController.dismissModalViewControllerAnimated(true)
  end
end